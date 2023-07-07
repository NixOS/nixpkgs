{ lib
, buildPythonPackage
, fetchPypi
, pytest
, zlib
, xz
}:

buildPythonPackage rec {
  pname = "deeptoolsintervals";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xnl80nblysj6dylj4683wgrfa425rkx4dp5k65hvwdns9pw753x";
  };

  buildInputs = [ zlib xz ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    homepage = "https://deeptools.readthedocs.io/en/develop";
    description = "Helper library for deeptools";
    license = licenses.mit;
    maintainers = with maintainers; [ scalavision ];
  };
}
