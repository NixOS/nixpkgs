{ stdenv, fetchFromGitHub, buildPythonPackage
, numpy }:

buildPythonPackage rec {
  pname = "fastcore";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = pname;
    rev = "dd36d6fb921af5fa8dc23d54701c18b831576fd6";
    sha256 = "0pm4w47i444wfix5kmbmvrx59p19ccnmr3z7smxv75bnbrxybjf6";
  };

  propagatedBuildInputs = [
    numpy
  ];

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    description = "Core functionality of fastai";
    homepage = "https://github.com/fastai/fastcore";
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
