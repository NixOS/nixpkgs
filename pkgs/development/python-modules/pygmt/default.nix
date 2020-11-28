{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, gmt
, numpy
, netcdf4
, pandas
, packaging
, xarray
}:

buildPythonPackage rec {
  pname = "pygmt";
  version = "0.2.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "pygmt";
    rev = "v${version}";
    sha256 = "1yx1n6mxfmwg69ls5560nm6d3jxyghv27981iplz7m7990bbp468";
  };

  postPatch = ''
    substituteInPlace pygmt/clib/loading.py \
      --replace "env.get(\"GMT_LIBRARY_PATH\", \"\")" "env.get(\"GMT_LIBRARY_PATH\", \"${gmt}/lib\")"
  '';

  propagatedBuildInputs = [ numpy netcdf4 pandas packaging xarray ];

  doCheck = false; # requires network access

  postBuild = "export HOME=$TMP";

  pythonImportsCheck = [ "pygmt" ];

  meta = with lib; {
    description = "A Python interface for the Generic Mapping Tools";
    homepage = "https://github.com/GenericMappingTools/pygmt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
  };
}
