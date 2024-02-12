{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, python
, isPy27
, six
, zope-testing
}:

buildPythonPackage rec {
  pname = "manuel";
  version = "1.12.4";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A5Wq32mR+SSseVz61Z2l3AYYcyqMxYrQ9HSWWrco9/Q=";
  };

  patches = lib.optionals (lib.versionAtLeast python.version "3.11") [
    # https://github.com/benji-york/manuel/pull/32
    # Applying conditionally until upstream arrives at some general solution.
    (fetchpatch {
      name = "TextTestResult-python311.patch";
      url = "https://github.com/benji-york/manuel/commit/d9f12d03e39bb76e4bb3ba43ad51af6d3e9d45c0.diff";
      hash = "sha256-k0vBtxEixoI1INiKtc7Js3Ai00iGAcCvCFI1ZIBRPvQ=";
    })
  ];

  propagatedBuildInputs = [ six ];
  nativeCheckInputs = [ zope-testing ];

  meta = with lib; {
    description = "A documentation builder";
    homepage = "https://pypi.python.org/pypi/manuel";
    license = licenses.zpl20;
  };

}
