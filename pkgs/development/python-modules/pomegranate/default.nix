{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonPackage rec {
  pname = "pomegranate";
  version = "0.7.7";
  name  = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = "pomegranate";
    owner = "jmschrei";
    rev = version;
    sha256 = "07zkg9jxjql00ppmkc4wsm2xidx58xnkmbbqaqv8jmh67y80yx75";
  };

  propagatedBuildInputs = with pythonPackages; [ numpy scipy cython networkx joblib ];

  buildInputs = [ pythonPackages.nose ];

  meta = with stdenv.lib; {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = https://github.com/jmschrei/pomegranate;
    license = licenses.mit;
    maintainers = with maintainers; [ rybern ];
  };
}
