{ lib, buildPythonPackage, fetchFromGitHub, numpy
}:

buildPythonPackage rec {
  pname = "colorspacious";
  version = "1.1.2";

  src = fetchFromGitHub {
     owner = "njsmith";
     repo = "colorspacious";
     rev = "v1.1.2";
     sha256 = "0x7nkphr6g5ql5fvgss8l56rgiyjgh6fm8zzs73i94ci9wzlm63w";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    homepage = "https://github.com/njsmith/colorspacious";
    description = "A powerful, accurate, and easy-to-use Python library for doing colorspace conversions ";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
