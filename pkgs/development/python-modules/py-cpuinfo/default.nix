{ lib
, fetchFromGitHub
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "py-cpuinfo";
  version = "4.0.0";

  src = fetchFromGitHub {
     owner = "workhorsy";
     repo = pname;
     rev = "v${version}";
     sha256 = "1pp561lj80jnvr2038nrzhmks2akxsbdqxvfrqa6n340x81981lm";
  };

  meta = {
    description = "Get CPU info with pure Python 2 & 3";
    homepage = https://github.com/workhorsy/py-cpuinfo;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
