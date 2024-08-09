{ fetchFromGitHub
, stdenvNoCC
, lib
, vcpkg-tool
, makeWrapper
, git
, doWrap ? true
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vcpkg";
  version = "2024.06.15";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vcpkg";
    rev = finalAttrs.version;
    hash = "sha256-7qYhslx/ZNJvlREB0DOs4YFGV105NWIvf/pOwykQ4i8=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ makeWrapper git ];

  postPatch = ''
    substituteInPlace scripts/toolchains/linux.cmake \
      --replace-fail "aarch64-linux-gnu-as"  "aarch64-unknown-linux-gnu-as" \
      --replace-fail "aarch64-linux-gnu-gcc" "aarch64-unknown-linux-gnu-gcc" \
      --replace-fail "aarch64-linux-gnu-g++" "aarch64-unknown-linux-gnu-g++" \
      --replace-fail "arm-linux-gnueabihf-as"  "armv7l-unknown-linux-gnueabihf-as" \
      --replace-fail "arm-linux-gnueabihf-gcc" "armv7l-unknown-linux-gnueabihf-gcc" \
      --replace-fail "arm-linux-gnueabihf-g++" "armv7l-unknown-linux-gnueabihf-g++"
    # If we don’t turn this off, then you won’t be able to run binaries that
    # are installed by vcpkg.
    find triplets -name '*linux*.cmake' -exec bash -c 'echo "set(X_VCPKG_RPATH_KEEP_SYSTEM_PATHS ON)" >> "$1"' -- {} \;
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/share/vcpkg/scripts/buildsystems"
      cp --preserve=mode -r ./{docs,ports,triplets,scripts,.vcpkg-root,versions,LICENSE.txt} "$out/share/vcpkg/"

      ${lib.optionalString doWrap ''
        makeWrapper "${vcpkg-tool}/bin/vcpkg" "$out/bin/vcpkg" \
          --set-default VCPKG_ROOT "$out/share/vcpkg"
      ''}

      ln -s "$out/bin/vcpkg" "$out/share/vcpkg/vcpkg"
      VCPKG_BASELINE_COMMIT_SHA=$(git rev-parse --verify HEAD)

      # Here's the code that Creates this json file in Visual Studio deployment and the code that reads it:
      #   https://github.com/microsoft/vcpkg-tool/blob/f098d3e0aaa7e46ea84a1f7079586e1ec5af8ab5/vcpkg-init/mint-standalone-bundle.ps1#L21
      #   https://github.com/microsoft/vcpkg-tool/blob/f098d3e0aaa7e46ea84a1f7079586e1ec5af8ab5/src/vcpkg/bundlesettings.cpp#L87
      #
      # Here's the code that we target with this setting. If we use embeddedsha combined with usegitregistry, vcpkg
      # will checkout a remote instead of trying to do git operation in the vcpkg root
      #   https://github.com/microsoft/vcpkg-tool/blob/d272c0d4f5175b26bd56c6109d4c4935b791a157/src/vcpkg/vcpkgpaths.cpp#L920
      #   https://github.com/microsoft/vcpkg-tool/blob/d272c0d4f5175b26bd56c6109d4c4935b791a157/src/vcpkg/configuration.cpp#L718
      echo '{ "readonly": true, "usegitregistry": true, "deployment": "Git", "embeddedsha": "'"$VCPKG_BASELINE_COMMIT_SHA"'" }' > "$out/share/vcpkg/vcpkg-bundle.json"
      touch "$out/share/vcpkg/vcpkg.disable-metrics"

      runHook postInstall
    '';

  meta = {
    description = "C++ Library Manager for Windows, Linux, and MacOS";
    mainProgram = "vcpkg";
    homepage = "https://vcpkg.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guekka gracicot h7x4 ];
    platforms = lib.platforms.all;
  };
})
