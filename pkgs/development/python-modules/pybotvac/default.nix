{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pybotvac";
  version = "0.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12qm4w883nb6fwff6sch5l133g3irqjcrgkjhh4mz1mmz7n6xzjh";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Python package for controlling Neato pybotvac Connected vacuum robot";
    homepage = https://github.com/stianaske/pybotvac;
    license = licenses.mit;
    maintainers = with maintainers; [ elseym ];
  };
}
