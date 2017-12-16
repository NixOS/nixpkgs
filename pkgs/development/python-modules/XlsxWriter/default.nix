{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "XlsxWriter";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mpq4l1jfghdqx2vzbzl9v28vw69lkx5vz9gb77gzaw8zypvnsx2";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
