{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.10.0";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-0o0zC8SUlug5xOV5AX9PiTim1td8NA4fq6WfBR5aSXA=";
  };

  propagatedBuildInputs = [ qtbase ];
}
