{ lib
, python3
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, click
, pygments
, urwid
, pytest-mock
, pytestCheckHook
, six
}:

let
  python3_ = python3.override {
    packageOverrides = self: super: {
      # Requires marshmallow<4,>=3.17.0
      # Currently marshmallow is version 3.16.0 in nixpkgs
      # Update of marshmallow to 3.19.0 breaks a bunch of other stuff
      marshmallow = super.marshmallow.overridePythonAttrs (oldAttrs: rec {
        name = "${oldAttrs.pname}-${version}";
        version = "3.19.0";
        src = fetchFromGitHub {
          owner = "marshmallow-code";
          repo = "marshmallow";
          rev = "refs/tags/${version}";
          sha256 = "sha256-b1brLHM48t45bwUXk7QreLLmvTzU0sX7Uoc1ZAgGkrE=";
        };
      });
      # Requires mistune>=0.8,<1
      mistune = super.mistune.overridePythonAttrs (oldAttrs: rec {
        name = "${oldAttrs.pname}-${version}";
        version = "0.8.4";
        src = fetchFromGitHub {
          owner = "lepture";
          repo = "mistune";
          rev = "refs/tags/v${version}";
          sha256 = "sha256-H9L2cJZVWvcbcWAF8ZMLGJGE7DO1h2wNZCbeFA02p7g=";
        };
      });
      # Requires PyYAML>=5,<6
      pyyaml = super.pyyaml.overridePythonAttrs (oldAttrs: rec {
        name = "${oldAttrs.pname}-${version}";
        version = "5.4.1.1";
        src = fetchFromGitHub {
          owner = "yaml";
          repo = "pyyaml";
          rev = "refs/tags/${version}";
          sha256 = "sha256-qLdAMqoyEXRIqcNuHBBtST8GWh5gmx5fBU/q3f4zaOw=";
        };
        checkPhase = ''
          runHook preCheck
          PYTHONPATH="tests/lib3:$PYTHONPATH" ${self.python.interpreter} -m test_all
          runHook postCheck
        '';
      });
    };
  };
in
with python3_.pkgs;
buildPythonPackage rec {
  pname = "lookatme";
  version = "2.5.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "d0c-s4vage";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-mn28OLIlxk97aDow1dTBsMRxVTkCqVeiAtrlyh8zJTg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    click
    marshmallow
    mistune
    pygments
    pyyaml
    urwid
  ];

  pythonImportsCheck = [ "lookatme" ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
    six
  ];

  # Tutorial added with recent version; tests are still flaky so let's disable them for now
  disabledTests = [
    "test_tutorial_basic"
    "test_tutor"
  ];

  meta = with lib; {
    description = "Interactive, extensible, terminal-based markdown presentation tool";
    homepage = "https://lookatme.readthedocs.io/en/v${version}/";
    changelog = "https://github.com/d0c-s4vage/lookatme/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ameer totoroot ];
  };
}
