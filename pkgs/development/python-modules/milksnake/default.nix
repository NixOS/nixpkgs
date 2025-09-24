{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  cffi,
}:

buildPythonPackage rec {
  pname = "milksnake";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "120nprd8lqis7x7zy72536gk2j68f7gxm8gffmx8k4ygifvl7kfz";
  };

  patches = [
    (fetchpatch {
      name = "fix-regex-python-311.patch";
      url = "https://github.com/getsentry/milksnake/commit/421cc1ffab4d76d01366240c087ffb30d63b744c.diff";
      hash = "sha256-U/C4CCX8SEOzVXNpOf4hVy2V3Lh6fUrFkz5z+h191C8=";
    })
  ];

  propagatedBuildInputs = [ cffi ];

  # tests rely on pip/venv
  doCheck = false;

  meta = with lib; {
    description = "Python library that extends setuptools for binary extensions";
    homepage = "https://github.com/getsentry/milksnake";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
