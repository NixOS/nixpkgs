{ stdenv, lib, fetchgit, buildGoModule, zlib, makeWrapper, xcodeenv, androidenv
, xcodeWrapperArgs ? { }
, xcodeWrapper ? xcodeenv.composeXcodeWrapper xcodeWrapperArgs
, withAndroidPkgs ? true
, androidPkgs ? androidenv.composeAndroidPackages {
    includeNDK = true;
    ndkVersion = "22.1.7171670";
  } }:

buildGoModule {
  pname = "gomobile";
  version = "unstable-2021-06-14";

  vendorSha256 = "1irgkgv72rakg7snk1bnp10ibr64ykz9l40s59l4fnl63zsh12a0";

  src = fetchgit {
    rev = "7c8f154d100840bc5828285bb390bbae1cb5a98c";
    name = "gomobile";
    url = "https://go.googlesource.com/mobile";
    sha256 = "1w9mra1mqf60iafp0ywvja5196fjsjyfhvz4yizqq4qkyll5qmj1";
  };

  subPackages = [ "bind" "cmd/gobind" "cmd/gomobile" ];

  # Fails with: go: cannot find GOROOT directory
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals stdenv.isDarwin [ xcodeWrapper ];

  # Prevent a non-deterministic temporary directory from polluting the resulting object files
  postPatch = ''
    substituteInPlace cmd/gomobile/env.go --replace \
      'tmpdir, err = ioutil.TempDir("", "gomobile-work-")' \
      'tmpdir = filepath.Join(os.Getenv("NIX_BUILD_TOP"), "gomobile-work")' \
      --replace '"io/ioutil"' ""
    substituteInPlace cmd/gomobile/init.go --replace \
      'tmpdir, err = ioutil.TempDir(gomobilepath, "work-")' \
      'tmpdir = filepath.Join(os.Getenv("NIX_BUILD_TOP"), "work")'
  '';

  # Necessary for GOPATH when using gomobile.
  postInstall = ''
    mkdir -p $out/src/golang.org/x
    ln -s $src $out/src/golang.org/x/mobile
    wrapProgram $out/bin/gomobile \
  '' + lib.optionalString withAndroidPkgs ''
      --prefix PATH : "${androidPkgs.androidsdk}/bin" \
      --set ANDROID_NDK_HOME "${androidPkgs.androidsdk}/libexec/android-sdk/ndk-bundle" \
      --set ANDROID_HOME "${androidPkgs.androidsdk}/libexec/android-sdk" \
  '' + ''
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zlib ]}"
  '';

  meta = with lib; {
    description = "A tool for building and running mobile apps written in Go";
    homepage = "https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakubgs ];
  };
}
