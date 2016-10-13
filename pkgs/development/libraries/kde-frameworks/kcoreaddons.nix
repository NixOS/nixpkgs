{ kdeFramework, lib, fetchurl, ecm, shared_mime_info }:

kdeFramework {
  name = "kcoreaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = [
    (fetchurl {
      url = "https://packaging.neon.kde.org/frameworks/kcoreaddons.git/plain/debian/patches/0001-Fix-very-old-bug-when-we-remove-space-in-url-as-foo-.patch?id=ab7258dd8a87668ba63c585a69f41f291254aa43";
      sha256 = "0svdqbikmslc0n2gdwwlbdyi61m5qgy0lxxv9iglbs3ja09xqs0p";
      name = "kcoreaddons-CVE-2016-7966.patch";
    })
  ];
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ shared_mime_info ];
}
