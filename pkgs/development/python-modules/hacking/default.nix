{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pbr
, pyflakes
, flake8
, pycodestyle
, mccabe
, enum34
, configparser
, six
, coverage
, fixtures
, mock
, subunit
, sphinx
, testrepository
, testscenarios
, testtools
, eventlet
, nose
}:

let pyflakes-100 = pyflakes.overrideDerivation (oldAttrs: rec {
      version = "1.0.0";
      src = fetchPypi {
         pname = oldAttrs.pname;
         inherit version;
         sha256 = "f39e33a4c03beead8774f005bd3ecf0c3f2f264fa0201de965fce0aff1d34263";
      };
    });

   mccabe-053 = mccabe.overrideDerivation (oldAttrs: rec {
      version = "0.5.3";
      src = fetchPypi {
         pname = oldAttrs.pname;
         inherit version;
         sha256 = "16293af41e7242031afd73896fef6458f4cad38201d21e28f344fff50ae1c25e";
      };
    });

   pycodestyle-200 = pycodestyle.overrideDerivation (oldAttrs: rec {
      version = "2.0.0";
      src = fetchPypi {
         pname = oldAttrs.pname;
         inherit version;
         sha256 = "37f0420b14630b0eaaf452978f3a6ea4816d787c3e6dcbba6fb255030adae2e7";
      };
    });

   flake8-262 = flake8.overrideDerivation (oldAttrs: rec {
      version = "2.6.2";
      src = fetchPypi {
         pname = oldAttrs.pname;
         inherit version;
         sha256 = "231cd86194aaec4bdfaa553ae1a1cd9b7b4558332fbc10136c044940d587a778";
      };
      patches = [ ];
      buildInputs = oldAttrs.buildInputs ++ [ nose ];
      propagatedBuildInputs = [ pyflakes-100 pycodestyle-200 mccabe-053 ]
        ++ stdenv.lib.optionals (pythonOlder "3.4") [ enum34 ]
        ++ stdenv.lib.optionals (pythonOlder "3.2") [ configparser ];
    });
in
buildPythonPackage rec {
  version = "1.1.0";
  pname = "hacking";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23a306f3a1070a4469a603886ba709780f02ae7e0f1fc7061e5c6fb203828fee";
  };

  # exclude openstacksdocstheme (circular dependency)
  checkInputs = [ coverage fixtures mock subunit sphinx testrepository testscenarios testtools eventlet ];
  propagatedBuildInputs = [ pbr flake8-262 six ];

  meta = with stdenv.lib; {
    homepage = https://docs.openstack.org/hacking/latest/;
    description = "OpenStack Hacking Guideline Enforcement";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
