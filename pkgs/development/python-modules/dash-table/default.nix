{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16q0d9fidllxm7p51i5p4vzknnc09d114zqw3f4a2spr7llga7xj";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A First-Class Interactive DataTable for Dash";
    homepage = "https://dash.plot.ly/datatable";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
