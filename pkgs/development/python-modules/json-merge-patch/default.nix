{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "json-merge-patch";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CYmLbUJ8CHVOKpfHCc8t/X4ovRDFaDpTiRSXXqt3jTk=";
  };

  patches = [
    # This prevented tests from running (was using a relative import)
    # https://github.com/OpenDataServices/json-merge-patch/pull/1
    (fetchpatch {
      name = "fully-qualified-json-merge-patch-import-on-tests";
      url = "https://patch-diff.githubusercontent.com/raw/OpenDataServices/json-merge-patch/pull/1.patch";
      sha256 = "1k6xsrxsmz03nwcqsf4gf0zsfnl2r20n83npic8z6bqlpl4lidl4";
    })
  ];

  meta = with lib; {
    description = "JSON Merge Patch library";
    mainProgram = "json-merge-patch";
    homepage = "https://github.com/open-contracting/json-merge-patch";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
