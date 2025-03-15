{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.8.2";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-SIvowzbDmoT06g6pcEbcRy7dXXx6N9jKhkuSr3Ej5P0=";
  };

  propagatedBuildInputs = [ qtbase ];
}
