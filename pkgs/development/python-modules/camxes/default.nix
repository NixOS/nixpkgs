{ lib
, jre
, buildPythonPackage
, fetchPypi
, progressbar
}:

let
  LEPL = buildPythonPackage rec {
    pname = "LEPL";
    version = "5.1.3";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "15qksjl1shj4gp47wf21h79qcs35h9b54pgdmzj0qd88jdq5qwd8";
    };
  };
in buildPythonPackage rec {
  pname = "camxes";
  version = "0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rhj40a60gq7giypxbhnbhlbz9if7ars1ba9vm1ak2izvdzh4mph";
  };

  postPatch = ''
    substituteInPlace camxes/__init__.py \
      --replace "'java'" "'java', '-Xss4m'"
  '';

  postInstall = ''
    mkdir -p $out/bin/
    cp ${./jbo2json.py} $out/bin/jbo2json
    chmod +x $out/bin/jbo2json
  '';

  # checkInputs = [ Attest ];
  propagatedBuildInputs = [ jre LEPL ];

  # checkPhase = ''
  # '';

  meta = with lib; {
    description = "Python interface to camxes, the Lojban parser";
    homepage = https://github.com/dag/python-camxes;
    license = licenses.bsd;
    maintainers = with maintainers; [ MostAwesomeDude ];
  };
}

