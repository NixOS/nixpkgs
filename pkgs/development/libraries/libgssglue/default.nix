{ lib, stdenv, fetchurl, libkrb5 }:

stdenv.mkDerivation rec {
  pname = "libgssglue";
  version = "0.4";

  src = fetchurl {
    url = "http://www.citi.umich.edu/projects/nfsv4/linux/libgssglue/${pname}-${version}.tar.gz";
    sha256 = "0fh475kxzlabwz30wz3bf7i8kfqiqzhfahayx3jj79rba1sily9z";
  };

  postPatch = ''
    sed s:/etc/gssapi_mech.conf:$out/etc/gssapi_mech.conf: -i src/g_initialize.c
  '';

  postInstall = ''
    mkdir -p $out/etc
    cat <<EOF > $out/etc/gssapi_mech.conf
    ${libkrb5}/lib/libgssapi_krb5.so mechglue_internal_krb5_init
    EOF
  '';

  meta = with lib; {
    homepage = "http://www.citi.umich.edu/projects/nfsv4/linux/";
    description = "Exports a gssapi interface which calls other random gssapi libraries";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ corngood ];
  };
}
