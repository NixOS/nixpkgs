{
  stdenv,
  lib,
  fetchgit,
  buildGoModule,
  zlib,
  makeWrapper,
  xcodeenv,
  androidenv,
  xcodeWrapperArgs ? { },
  xcodeWrapper ? xcodeenv.composeXcodeWrapper xcodeWrapperArgs,
  withAndroidPkgs ? true,
  androidPkgs ? androidenv.composeAndroidPackages {
    includeNDK = true;
    ndkVersion = "27.0.12077973";
  },
}:

buildGoModule {
  pname = "gomobile";
  version = "0-unstable-2024-11-8";

  vendorHash = "sha256-xTl8Hd1+GHRrUb5ktl1XkQa18HsHIeEvnujrcK0E1eU=";

  src = fetchgit {
    rev = "fa514ef75a0ffd7d89e1b4c9b45485f7bb39cf83";
    name = "gomobile";
    url = "https://go.googlesource.com/mobile";
    sha256 = "sha256-vuh6Rw27WA0BId+8JUqZdNCrvUH2sorvv15eIK/GFj0=";
  };

  subPackages = [
    "bind"
    "cmd/gobind"
    "cmd/gomobile"
  ];

  # Fails with: go: cannot find GOROOT directory
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodeWrapper ];

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

  postFixup =
    ''
      for bin in $(ls $out/bin); do
        wrapProgram $out/bin/$bin \
          --suffix GOPATH : $out \
    ''
    + lib.optionalString withAndroidPkgs ''
      --prefix PATH : "${androidPkgs.androidsdk}/bin" \
      --set-default ANDROID_HOME "${androidPkgs.androidsdk}/libexec/android-sdk" \
    ''
    + ''
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ zlib ]}"
      done
    '';

  meta = {
    description = "Tool for building and running mobile apps written in Go";
    homepage = "https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jakubgs ];
  };
}
