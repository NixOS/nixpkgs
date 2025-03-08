{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pandas,
  korean-lunar-calendar,
  toolz,
  pyluach,

  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage {
  pname = "exchange-calendars";
  version = "4.9";
  format = "pyproject";
  src = fetchFromGitHub {
    owner = "gerrymanoim";
    repo = "exchange_calendars";
    rev = "4.9";
    sha256 = "sha256-4ivk7vgcdBCsH5N+bFTnTdli+Tof0qIrZMmf21lmeWw=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    korean-lunar-calendar
    toolz
    pandas
    pyluach
  ];

  # Seems like there are errors upstream with XPHS (Phillipines).
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ hypothesis ];

  meta = with lib; {
    description = "Library for defining and querying calendars for security exchanges";
    homepage = "https://github.com/gerrymanoim/exchange_calendars";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thardin ];
  };
}
