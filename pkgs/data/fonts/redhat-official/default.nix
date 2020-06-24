{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "redhat-official";
  version = "2.2.0";

  src = fetchzip {
    url = "https://github.com/RedHatOfficial/RedHatFont/archive/${version}.zip";
    sha256 = "1vahpsg2qni9d73jkpfqp2jymvixdmwykwrcbhh0qafhcgg1iiwi";
  };

  meta = with lib; {
    homepage = "https://github.com/RedHatOfficial/RedHatFont";
    description = "Red Hat's Open Source Fonts - Red Hat Display and Red Hat Text";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
