{ stdenv, buildPythonPackage, fetchpatch, fetchFromGitHub,
  python, cmake, git, swig, boost, udev,
  setuptools, enum34, wrapt, future }:

buildPythonPackage rec {
  pname = "pc-ble-driver-py";
  version = "0.11.4";
  disabled = python.isPy3k;

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-ble-driver-py";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0lgmcnrlcivmawmlcwnn4pdp6afdbnf3fyfgq22xzs6v72m9gp81";
  };

  nativeBuildInputs = [ cmake swig git setuptools ];
  buildInputs = [ boost udev ];
  propagatedBuildInputs = [ enum34 wrapt future ];

  patches = [
    # build system expects case-insensitive file system
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/NordicSemiconductor/pc-ble-driver-py/pull/84.patch";
      sha256 = "0ibx5g2bndr5h9sfnx51bk9b62q4jvpdwhxadbnj3da8kvcz13cy";
    })
  ];

  postPatch = ''
    # do not force static linking of boost
    sed -i /Boost_USE_STATIC_LIBS/d pc-ble-driver/cmake/*.cmake

    cd python
  '';

  preBuild = ''
    pushd ../build
    cmake ..
    make -j $NIX_BUILD_CORES
    popd
  '';

  meta = with stdenv.lib; {
    description = "Bluetooth Low Energy nRF5 SoftDevice serialization";
    homepage = "https://github.com/NordicSemiconductor/pc-ble-driver-py";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
