{
  qtModule,
  fetchFromGitHub,
  qtbase,
  qtdeclarative,
  openssl,
}:

qtModule rec {
  pname = "qtopcua";
  version = "6.12.0";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtopcua";
    tag = "v${version}";
    hash = "sha256-FgVsRVAoK31s2+lSgcMmAn2z58LtbLAtzEGxsooi1kE=";
  };

  buildInputs = [ openssl ];

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  # Build the bundled open62541 backend with encryption support.
  cmakeFlags = [
    "-DINPUT_open62541=qt"
    "-DFEATURE_open62541_security=ON"
  ];
}
