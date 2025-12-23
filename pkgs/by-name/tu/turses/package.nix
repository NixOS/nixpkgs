{
  lib,
  fetchpatch,
  fetchFromGitHub,
  fetchPypi,
  python3,
}:

let
  py = python3.override {
    self = py;
    packageOverrides = self: super: {

      # Support for later tweepy releases is missing
      # https://github.com/louipc/turses/issues/12
      tweepy = super.tweepy.overridePythonAttrs (oldAttrs: rec {
        version = "3.10.0";

        src = fetchFromGitHub {
          owner = "tweepy";
          repo = "tweepy";
          tag = "v${version}";
          hash = "sha256-3BbQeCaAhlz9h5GnhficNubJHu4kTpnCDM4oKzlti0w=";
        };
        dependencies = oldAttrs.dependencies ++ [
          super.six
          super.requests.optional-dependencies.socks
        ];
        doCheck = false;
      });
    };
  };
in
with py.pkgs;

buildPythonPackage rec {
  pname = "turses";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RqYVQdGs0TOFYaGYswEQgbkfEYQVwIsRFETNskaFs5Y=";
  };

  pythonRelaxDeps = [
    "urwid"
    "future"
    "tweepy"
  ];

  postPatch = ''
    substituteInPlace tests/test_config.py \
      --replace-fail "config.generate_config_file.assert_called_once()" "assert config.generate_config_file.call_count == 1"
    substituteInPlace tests/test_meta.py \
      --replace-fail "self.observer.update.assert_called_once()" "assert self.observer.update.call_count == 1"
  '';

  build-system = with py.pkgs; [ setuptools ];

  dependencies = with py.pkgs; [
    urwid
    tweepy
    future
  ];

  nativeCheckInputs = with py.pkgs; [
    mock
    pytest
    coverage
    tox
  ];

  LC_ALL = "en_US.UTF-8";

  patches = [
    (fetchpatch {
      url = "https://github.com/louipc/turses/commit/be0961b51f502d49fd9e2e5253ac130e543a31c7.patch";
      sha256 = "17s1n0275mcj03vkf3n39dmc09niwv4y7ssrfk7k3vqx22kppzg3";
    })
    # python 3.7+ support
    (fetchpatch {
      url = "https://github.com/booxter/turses/commit/e6e285eae50fc3d2042a476185fe60daef1e758e.patch";
      sha256 = "0g2zsrny955viwgs2l6gpiiz8m67b5sgdcxkjmfimfvvih5sg79f";
    })
  ];

  checkPhase = ''
    TMP_TURSES=`echo turses-$RANDOM`
    mkdir $TMP_TURSES
    PYTHONPATH=tests:$PYTHONPATH HOME=$TMP_TURSES py.test tests/
    rm -rf $TMP_TURSES
  '';

  meta = {
    description = "Twitter client for the console";
    homepage = "https://github.com/louipc/turses";
    changelog = "https://github.com/louipc/turses/blob/v${version}/HISTORY.rst";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "turses";
    platforms = lib.platforms.unix;
  };
}
