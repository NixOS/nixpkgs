{ stdenv, lib, fetchgit, buildGoModule, zlib, makeWrapper, xcodeenv, androidenv
, xcodeWrapperArgs ? { }
, xcodeWrapper ? xcodeenv.composeXcodeWrapper xcodeWrapperArgs
, androidPkgs ? androidenv.composeAndroidPackages {
    includeNDK = true;
    ndkVersion = "21.3.6528147"; # WARNING: 22.0.7026061 is broken.
  } }:

buildGoModule {
  pname = "gomobile";
  version = "unstable-2020-06-22";

  vendorSha256 = "1n1338vqkc1n8cy94501n7jn3qbr28q9d9zxnq2b4rxsqjfc9l94";

  src = fetchgit {
    # WARNING: Next commit removes support for ARM 32 bit builds for iOS
    rev = "33b80540585f2b31e503da24d6b2a02de3c53ff5";
    name = "gomobile";
    url = "https://go.googlesource.com/mobile";
    sha256 = "0c9map2vrv34wmaycsv71k4day3b0z5p16yzxmlp8amvqb38zwlm";
  };

  subPackages = [ "bind" "cmd/gobind" "cmd/gomobile" ];

  # Fails with: go: cannot find GOROOT directory
  doCheck = false;

  patches = [ ./resolve-nix-android-sdk.patch ];

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
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zlib ]}" \
      --prefix PATH : "${androidPkgs.androidsdk}/bin" \
      --set ANDROID_HOME "${androidPkgs.androidsdk}/libexec/android-sdk" \
      --set GOPATH $out
  '';

  meta = with lib; {
    description = "A tool for building and running mobile apps written in Go";
    homepage = "https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakubgs ];
  };
}
