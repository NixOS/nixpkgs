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
  version = "unstable-2022-05-18";

  vendorHash = "sha256-AmOy3X+d2OD7ZLbFuy+SptdlgWbZJaXYEgO79M64ufE=";

  src = fetchgit {
    rev = "8578da9835fd365e78a6e63048c103b27a53a82c";
    name = "gomobile";
    url = "https://go.googlesource.com/mobile";
    sha256 = "sha256-AOR/p+DW83f2+BOxm2rFXBCrotcIyunK3UzQ/dnauWY=";
  };

  subPackages = [ "bind" "cmd/gobind" "cmd/gomobile" ];

  # Fails with: go: cannot find GOROOT directory
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodeWrapper ];

  # Prevent a non-deterministic temporary directory from polluting the resulting object files
  postPatch = ''
    substituteInPlace cmd/gomobile/env.go --replace \
      'tmpdir, err = ioutil.TempDir("", "gomobile-work-")' \
      'tmpdir = filepath.Join(os.Getenv("NIX_BUILD_TOP"), "gomobile-work")'
    substituteInPlace cmd/gomobile/init.go --replace \
      'tmpdir, err = ioutil.TempDir(gomobilepath, "work-")' \
      'tmpdir = filepath.Join(os.Getenv("NIX_BUILD_TOP"), "work")'
  '';

  # Necessary for GOPATH when using gomobile.
  postInstall = ''
    mkdir -p $out/src/golang.org/x
    ln -s $src $out/src/golang.org/x/mobile
  '';

  postFixup = ''
    for bin in $(ls $out/bin); do
      wrapProgram $out/bin/$bin \
        --suffix GOPATH : $out \
  '' + lib.optionalString withAndroidPkgs ''
        --prefix PATH : "${androidPkgs.androidsdk}/bin" \
        --set-default ANDROID_HOME "${androidPkgs.androidsdk}/libexec/android-sdk" \
  '' + ''
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zlib ]}"
    done
  '';

  meta = with lib; {
    description = "Tool for building and running mobile apps written in Go";
    homepage = "https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakubgs ];
  };
}
