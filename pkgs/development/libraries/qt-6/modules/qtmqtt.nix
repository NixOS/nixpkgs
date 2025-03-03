{
  qtModule,
  fetchFromGitHub,
  qtbase,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.8.0";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    rev = "v${version}";
    hash = "sha256-WvqBEq7Zv1CONMMuDHdj8/nJHoY4y7ysrqliTZHi7x8=";
  };

  propagatedBuildInputs = [ qtbase ];
}
