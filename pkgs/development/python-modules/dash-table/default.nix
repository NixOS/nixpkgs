{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "dash-table";
  version = "5.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "dash_table";
    inherit version;
    hash = "sha256-GGJNaT1MjvLd7Jmm8WdZNDen6gvxU6og8xjBcMW8cwg=";
  };

  # No tests in archive
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "First-Class Interactive DataTable for Dash";
    homepage = "https://dash.plot.ly/datatable";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.antoinerg ];
=======
  meta = with lib; {
    description = "First-Class Interactive DataTable for Dash";
    homepage = "https://dash.plot.ly/datatable";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
