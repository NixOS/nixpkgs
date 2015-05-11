{ stdenv, fetchurl

# Optional Dependencies
, shishi ? null
}:

stdenv.mkDerivation rec {
  name = "gss-1.0.2";

  src = fetchurl {
    url = "mirror://gnu/gss/${name}.tar.gz";
    sha256 = "1qa8lbkzi6ilfggx7mchfzjnchvhwi68rck3jf9j4425ncz7zsd9";
  };

  buildInputs = [ shishi ];

  configureFlags = [
    "--${if shishi != null then "enable" else "disable"}-kereberos5"
  ];

  doCheck = true;

  # Fixup .la files
  postInstall = stdenv.lib.optionalString (!stdenv.isDarwin && shishi != null) ''
    sed -i 's,\(-lshishi\),-L${shishi}/lib \1,' $out/lib/libgss.la
  '';

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/gss/;
    description = "Generic Security Service";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bjg wkennington ];
    platforms = platforms.all;
  };
}
