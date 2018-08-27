{lib, buildPythonPackage, fetchPypi, setuptools, wheel, pytest}:

buildPythonPackage rec {
  name = "pex-${version}";
  version = "1.4.5";

  src = fetchPypi {
    pname  = "pex";
    sha256 = "04s9qvx87ngfs3m91qsrmk0ll16s0ldrvlxjbg4y1ic4bgsjq3hj";
    inherit version;
  };

  propagatedBuildInputs = [ setuptools wheel ];
  checkInputs = [ pytest ];

  prePatch = ''
    substituteInPlace setup.py --replace 'SETUPTOOLS_REQUIREMENT,' '"setuptools",'
    substituteInPlace setup.py --replace 'WHEEL_REQUIREMENT,' '"wheel",'
  '';

  patches = [ ./set-source-date-epoch.patch ];

  meta = {
    description = "A library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}
