let
  pname = "libsbsms";
in
pkgs: rec {
  libsbsms_2_0_2 = pkgs.callPackage ./common.nix rec {
    inherit pname;
    version = "2.0.2";
    url = "mirror://sourceforge/sbsms/${pname}-${version}.tar.gz";
    sha256 = "sha256-zqs9lwZkszcFe0a89VKD1Q0ynaY2v4PQ7nw24iNBru4=";
    homepage = "https://sourceforge.net/projects/sbsms/files/sbsms";
  };

  libsbsms_2_3_0 = pkgs.callPackage ./common.nix rec {
    inherit pname;
    version = "2.3.0";
    url = "https://github.com/claytonotey/${pname}/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-T4jRUrwG/tvanV1lUX1AJUpzEMkFBgGpMSIwnUWv0sk=";
    homepage = "https://github.com/claytonotey/libsbsms";
  };

  libsbsms = libsbsms_2_0_2;
}
