{
  lib,
  runCommand,
  flutter347,
  writableTmpDirAsHomeHook,
  pluginIntegration ? "swiftpm",
}:

let
  flutter = flutter347.override {
    supportedTargetFlutterPlatforms = [
      "universal"
      "macos"
    ];
  };
  src =
    runCommand "flutter-macos-test-source"
      {
        nativeBuildInputs = [
          flutter
          writableTmpDirAsHomeHook
        ];
      }
      ''
        flutter config --no-analytics >/dev/null
        flutter create --empty --no-pub --platforms=macos --project-name=nix_flutter_test source
        flutter create --template=plugin --no-pub --platforms=macos --project-name=nix_test_plugin source/plugin
        flutter create --template=plugin --no-pub --platforms=macos --project-name=nix_legacy_plugin source/legacy_plugin
        cp -r source "$out"
        cat > "$out/pubspec.yaml" <<'EOF'
        name: nix_flutter_test
        version: 0.1.0+1
        environment:
          sdk: ^3.13.3
        dependencies:
          flutter:
            sdk: flutter
          nix_test_plugin:
            path: plugin
          nix_legacy_plugin:
            path: legacy_plugin
        flutter:
          uses-material-design: true
        EOF
        cat > "$out/plugin/pubspec.yaml" <<'EOF'
        name: nix_test_plugin
        version: 0.0.1
        environment:
          sdk: ^3.13.3
          flutter: '>=3.47.4'
        dependencies:
          flutter:
            sdk: flutter
        flutter:
          plugin:
            platforms:
              macos:
                pluginClass: NixTestPlugin
        EOF
        cat > "$out/legacy_plugin/pubspec.yaml" <<'EOF'
        name: nix_legacy_plugin
        version: 0.0.1
        environment:
          sdk: ^3.13.3
          flutter: '>=3.47.4'
        dependencies:
          flutter:
            sdk: flutter
        flutter:
          plugin:
            platforms:
              macos:
                pluginClass: NixLegacyPlugin
        EOF
        ${lib.optionalString (pluginIntegration == "mixed") ''
          # Exercise CocoaPods fallback while the other plugin uses SwiftPM.
          rm "$out/legacy_plugin/macos/nix_legacy_plugin/Package.swift"
        ''}
        echo 'library;' > "$out/legacy_plugin/lib/nix_legacy_plugin.dart"
        echo 'library;' > "$out/plugin/lib/nix_test_plugin.dart"
        # Exercise bundle and executable names that differ from pname and contain spaces.
        substituteInPlace "$out/macos/Runner/Configs/AppInfo.xcconfig" \
          --replace-fail 'PRODUCT_NAME = nix_flutter_test' 'PRODUCT_NAME = Flutter Test'
      '';
in
flutter347.buildFlutterApplication {
  pname = "flutter-macos-test";
  version = "0.1.0";
  inherit src;
  pubspecLock = lib.importJSON ./macos-pubspec.lock.json;

  preBuild = ''
    # Native hooks use the Nix toolchain before Flutter selects full Xcode.
    cat > native-check.cc <<'EOF'
    #include <cstdint>
    #include <vector>
    int main() { return std::vector<std::uint64_t>{42}.front() != 42; }
    EOF
    $CXX native-check.cc -o native-check
    ./native-check

    # An upstream App Store profile must not override ad hoc signing.
    cat >> macos/Runner/Configs/AppInfo.xcconfig <<'EOF'
    CODE_SIGN_STYLE = Manual
    PROVISIONING_PROFILE_SPECIFIER[sdk=macosx*] = NixFixture App Store Profile
    EOF
    flutter config --${
      lib.optionalString (pluginIntegration == "cocoapods") "no-"
    }enable-swift-package-manager
  ''
  + lib.optionalString (pluginIntegration == "cocoapods") ''
    export FLUTTER_XCODE_ENABLE_HARDENED_RUNTIME=YES
    install -m644 ${flutter}/packages/flutter_tools/templates/cocoapods/Podfile-macos macos/Podfile
    mkdir fixture-pod
    echo 'int nix_fixture(void) { return 1; }' > fixture-pod/fixture.c
    cat > fixture-pod/NixFixture.podspec <<'EOF'
    Pod::Spec.new do |s|
      s.name = 'NixFixture'
      s.version = '1.0.0'
      s.summary = 'Test a custom local native dependency'
      s.homepage = 'https://example.org'
      s.license = 'MIT'
      s.author = 'Nixpkgs'
      s.source = { :path => '.' }
      s.platform = :osx, '10.15'
      s.source_files = 'fixture.c'
    end
    EOF
    cat >> macos/Podfile <<'EOF'
    pod 'NixFixture', :path => '../fixture-pod'
    fixture_original_post_install = method(:post_install!)
    define_singleton_method(:post_install!) do |installer|
      fixture_original_post_install.call(installer)
      File.write(File.join(ENV.fetch('NIX_BUILD_TOP'), 'fixture-post-install'), 'preserved')
    end
    EOF
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    test -d "$out/Applications/Flutter Test.app/Contents/Frameworks/App.framework"
    test -x "$out/bin/$pname"
    test ! -L "$out/bin/$pname"
    grep -Fq \
      "$out/Applications/Flutter Test.app/Contents/MacOS/Flutter Test" "$out/bin/$pname"
    test -x \
      "$out/Applications/Flutter Test.app/Contents/MacOS/Flutter Test"
    /usr/bin/codesign --verify --deep "$out/Applications/Flutter Test.app"
    /usr/bin/codesign --display --entitlements - --xml "$out/Applications/Flutter Test.app" > entitlements.plist
    test "$(/usr/libexec/PlistBuddy -c 'Print :com.apple.security.app-sandbox' entitlements.plist)" = true

    ${lib.optionalString (pluginIntegration == "swiftpm") ''
      test ! -e macos/Podfile
    ''}
    ${lib.optionalString (pluginIntegration != "swiftpm") ''
      test -d macos/Pods
      grep -q nix_legacy_plugin macos/Podfile.lock
    ''}
    ${lib.optionalString (pluginIntegration == "mixed") ''
      grep -q nix-test-plugin macos/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage/Package.swift
    ''}
    ${lib.optionalString (pluginIntegration == "cocoapods") ''
      test "$(/usr/libexec/PlistBuddy -c 'Print :com.apple.security.cs.disable-library-validation' entitlements.plist)" = true
      /usr/bin/codesign --display --verbose "$out/Applications/Flutter Test.app" 2>&1 | grep -q 'flags=.*runtime'
      grep -q NixFixture macos/Podfile.lock
      test "$(cat "$NIX_BUILD_TOP/fixture-post-install")" = preserved
    ''}
    runHook postInstallCheck
  '';

  meta.platforms = [ "aarch64-darwin" ];
  meta.hydraPlatforms = [ ];
}
