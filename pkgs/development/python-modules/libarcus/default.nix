{ lib, buildPythonPackage, python, fetchFromGitHub
, fetchpatch
, cmake, sip, protobuf, pythonOlder }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "5.2.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "1rcymbgk3fijmsa1vdicgrcp45igvrsh30rld989mmqd04chmr4x";
  };

  patches = [
    # Imported from Alpine:
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/libarcus/cmake-build.patch?id=ad078141cb02378fe42aedea4271f4beb2fd2f01";
      name = "libarcus-cmake-build.patch";
      sha256 = "0v0cxhaazq29psq9idcv16ngvp30j3h5xghx8vb9n79zl1a9b82n";
    })
    # Imported from Alpine:
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/libarcus/ArcusConfig.patch?id=2a3bb5dbbb9f049578f7d2ca55f22dc7db635bfd";
      name = "libarcus-ArcusConfig.patch";
      sha256 = "1yq4a3r6q3bq22adsmzh9048q6db9qrwp1cl51xp1x7j9b9cxgda";
    })
  ];

  disabled = pythonOlder "3.4";

  propagatedBuildInputs = [ sip ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ];

  cmakeFlags = [
    # The `libarcus-cmake-build.patch` above adds a line with `set_target_properties()` that requires this.
    "-DARCUS_VERSION=${version}"
  ];

  meta = with lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
