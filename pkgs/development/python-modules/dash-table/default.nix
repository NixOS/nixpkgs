{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90f6a46a25a86810aa80281f4f186941a3fc37ff1d2526452ccfe7c102ab6d2a";
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
