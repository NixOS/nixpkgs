{ lib, stdenv, ruby, rake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mruby";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner   = "mruby";
    repo    = "mruby";
    rev     = version;
    sha256  = "sha256-MmrbWeg/G29YBvVrOtceTOZChrQ2kx9+apl7u7BiGjA=";
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

  meta = with lib; {
    description = "An embeddable implementation of the Ruby language";
    homepage = "https://mruby.org";
    maintainers = with maintainers; [ nicknovitski marsam ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
