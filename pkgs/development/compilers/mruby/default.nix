{
  lib,
  stdenv,
  ruby,
  rake,
  fetchFromGitHub,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mruby";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "mruby";
    repo = "mruby";
    rev = finalAttrs.version;
    sha256 = "sha256-rCoEC1ioX6bOocPoPi+Lsn4PM8gY0DjKja1/MJvJ1n8=";
  };

  nativeBuildInputs = [ rake ];

  nativeCheckInputs = [ ruby ];

  # Necessary so it uses `gcc` instead of `ld` for linking.
  # https://github.com/mruby/mruby/blob/e502fd88b988b0a8d9f31b928eb322eae269c45a/tasks/toolchains/gcc.rake#L30
  preBuild = "unset LD";

  installPhase = ''
    mkdir $out
    cp -R include build/host/{bin,lib} $out
  '';

  doCheck = true;

  checkTarget = "test";

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "An embeddable implementation of the Ruby language";
    homepage = "https://mruby.org";
    maintainers = with maintainers; [ nicknovitski ];
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "mruby";
  };
})
