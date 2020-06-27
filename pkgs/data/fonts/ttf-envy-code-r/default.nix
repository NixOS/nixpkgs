{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "ttf-envy-code-r";
  version = "PR7";
  # kept for compatibility
  name = "${pname}-0.${version}";

  src = fetchzip {
    url = "http://download.damieng.com/fonts/original/EnvyCodeR-${version}.zip";
    sha256 = "1hys10zibam4jk8sq3ppyk73j4ih2xd0kxjpdlq133ydqvz856m4";
  };

  meta = with lib; {
    homepage = "https://damieng.com/blog/tag/envy-code-r";
    description = "Free scalable coding font by DamienG";
    license = licenses.unfree;
    maintainers = with maintainers; [ lyt ];
  };
}
