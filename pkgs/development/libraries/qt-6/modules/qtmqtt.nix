{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.11.0";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-7X+HWAftWHn40RPFQD3/f+bp00LQk8Vsb871WfxdZSE=";
  };

  propagatedBuildInputs = [ qtbase ];
}
