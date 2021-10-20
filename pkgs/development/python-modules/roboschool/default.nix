{ lib
, buildPythonPackage
, isPy3k
, python
, fetchFromGitHub
, fetchpatch
, qtbase
, boost
, assimp
, gym
, bullet-roboschool
, pkg-config
, which
}:

buildPythonPackage rec {
  pname = "roboschool";
  version = "1.0.39";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "roboschool";
    rev = version;
    sha256 = "1s7rp5bbiglnrfm33wf7x7kqj0ks3b21bqyz18c5g6vx39rxbrmh";
  };

  # fails to find boost_python for some reason
  disabled = !isPy3k;

  propagatedBuildInputs = [
    gym
  ];

  nativeBuildInputs = [
    pkg-config
    qtbase # needs the `moc` tool
    which
  ];

  buildInputs = [
    bullet-roboschool
    assimp
    qtbase
    boost
  ];

  dontWrapQtApps = true;

  NIX_CFLAGS_COMPILE="-I ${python}/include/${python.libPrefix}";

  patches = [
    # Remove kwarg that was removed in upstream gym
    # https://github.com/openai/roboschool/pull/180
    (fetchpatch {
      name = "remove-close-kwarg.patch";
      url = "https://github.com/openai/roboschool/pull/180/commits/334f489c8ce7af4887e376139ec676f89da5b16f.patch";
      sha256 = "0bbz8b63m40a9lrwmh7c8d8gj9kpa8a7svdh08qhrddjkykvip6r";
    })
  ];

  preBuild = ''
    # First build the cpp dependencies
    cd roboschool/cpp-household
    make \
      MOC=moc \
      -j$NIX_BUILD_CORES
    cd ../..
  '';

  # Does a QT sanity check, but QT is not expected to work in isolation
  doCheck = false;

  meta = with lib; {
    description = "Open-source software for robot simulation, integrated with OpenAI Gym";
    homepage = "https://github.com/openai/roboschool";
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
