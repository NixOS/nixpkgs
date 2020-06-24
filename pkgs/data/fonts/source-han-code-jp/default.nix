{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "source-han-code-jp";
  version = "2.011";

  src = fetchzip {
    url = "https://github.com/adobe-fonts/${pname}/archive/${version}R.zip";
    sha256 = "1grcnmfp74pc7l448jswyyrixfklrm45pkyznw5vz9q3ygfdx4y6";
  };

  meta = with lib; {
    description = "A monospaced Latin font suitable for coding";
    homepage = "https://blogs.adobe.com/CCJKType/2015/06/source-han-code-jp.html";
    license = licenses.ofl;
    platforms = with platforms; all;
    maintainers = with maintainers; [ mt-caret ];
  };
}
