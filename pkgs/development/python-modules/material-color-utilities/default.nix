{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pillow
, regex
,
}:
buildPythonPackage rec {
  pname = "material-color-utilities";
  version = "0.1.5";

  src = fetchPypi {
    pname = "${pname}-python";
    inherit version;
    sha256 = "sha256-PG8C585wWViFRHve83z3b9NijHyV+iGY2BdMJpyVH64=";
  };

  buildInputs = [ poetry-core ];
  propagatedBuildInputs = [ pillow regex ];

  meta = with lib; {
    description = "Python port of material-color-utilities used for Material You colors";
    license = licenses.asl20;
    maintainers = with maintainers; [ getchoo ];
    platforms = platforms.all;
  };
}
