{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyroute2";
<<<<<<< HEAD
  version = "0.9.5";
  pyproject = true;

=======
  version = "0.9.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "svinota";
    repo = "pyroute2";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-KPXDXRQWonuTyy1SsvgO7jXjawiRj1XJ3zte5ZHanRw=";
=======
    hash = "sha256-D603ZrLbc/6REx6X0bMvZzeyo0fgTsFL7J+iRTiQLgQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  # Requires root privileges, https://github.com/svinota/pyroute2/issues/778
  doCheck = false;

  pythonImportsCheck = [
    "pyroute2"
    "pyroute2.common"
    "pyroute2.config"
    "pyroute2.ethtool"
    "pyroute2.ipdb"
    "pyroute2.ipset"
    "pyroute2.ndb"
    "pyroute2.nftables"
    "pyroute2.nslink"
    "pyroute2.protocols"
  ];

  postPatch = ''
    patchShebangs util
    make VERSION
  '';

<<<<<<< HEAD
  meta = {
    description = "Python Netlink library";
    homepage = "https://github.com/svinota/pyroute2";
    changelog = "https://github.com/svinota/pyroute2/blob/${src.tag}/CHANGELOG.rst";
    license = with lib.licenses; [
      asl20 # or
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      fab
      mic92
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Python Netlink library";
    homepage = "https://github.com/svinota/pyroute2";
    changelog = "https://github.com/svinota/pyroute2/blob/${src.tag}/CHANGELOG.rst";
    license = with licenses; [
      asl20 # or
      gpl2Plus
    ];
    maintainers = with maintainers; [
      fab
      mic92
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
