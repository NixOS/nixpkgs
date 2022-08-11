{ lib, stdenv, fetchurl
, withShishi ? !stdenv.isDarwin, shishi
}:

stdenv.mkDerivation rec {
  pname = "gss";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://gnu/gss/gss-${version}.tar.gz";
    sha256 = "sha256-7M6r3vTK4/znIYsuy4PrQifbpEtTthuMKy6IrgJBnHM=";
  };

  buildInputs = lib.optional withShishi shishi;

  configureFlags = [
    "--${if withShishi then "enable" else "disable"}-kerberos5"
  ];

  doCheck = true;

  # Fixup .la files
  postInstall = lib.optionalString withShishi ''
    sed -i 's,\(-lshishi\),-L${shishi}/lib \1,' $out/lib/libgss.la
  '';

  meta = with lib; {
    homepage = "https://www.gnu.org/software/gss/";
    description = "Generic Security Service";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
