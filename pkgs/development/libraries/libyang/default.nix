{ stdenv
, lib
, fetchFromGitHub
, cmake
, pcre
, pkg-config
, genericUpdater
, common-updater-scripts
}:

stdenv.mkDerivation rec {
  pname = "libyang";
  version = "1.0.240";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang";
    rev = "v${version}";
    sha256 = "12hzwm0jszhnbmn0a03pljpz18dzsrqn91z6y62ghci26qi3xcxn";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ pcre ];
  cmakeFlags = [ "-DENABLE_LYD_PRIV=ON" "-DCMAKE_BUILD_TYPE:String=Release" ];

  passthru.updateScript = genericUpdater {
    inherit pname version;
    versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
    ignoredVersions = "^2\.";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "YANG data modelling language parser and toolkit";
    longDescription = ''
      libyang is a YANG data modelling language parser and toolkit written (and
      providing API) in C. The library is used e.g. in libnetconf2, Netopeer2,
      sysrepo or FRRouting projects.
    '';
    homepage = "https://github.com/CESNET/libyang";
    license = with licenses; [ bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ woffs ];
  };
}
