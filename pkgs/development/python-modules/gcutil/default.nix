{ stdenv
, buildPythonPackage
, fetchurl
, gflags
, iso8601
, ipaddr
, httplib2
, google_apputils
, google_api_python_client
, isPy3k
}:

buildPythonPackage rec {
  name = "gcutil-1.16.1";
  disabled = isPy3k;

  src = fetchurl {
    url = https://dl.google.com/dl/cloudsdk/release/artifacts/gcutil-1.16.1.tar.gz;
    sha256 = "00jaf7x1ji9y46fbkww2sg6r6almrqfsprydz3q2swr4jrnrsx9x";
  };

  propagatedBuildInputs = [ gflags iso8601 ipaddr httplib2 google_apputils google_api_python_client ];

  prePatch = ''
    sed -i -e "s|google-apputils==0.4.0|google-apputils==0.4.1|g" setup.py
    substituteInPlace setup.py \
      --replace "httplib2==0.8" "httplib2" \
      --replace "iso8601==0.1.4" "iso8601" \
      --replace "ipaddr==2.1.10" "ipaddr" \
      --replace "google-api-python-client==1.2" "google-api-python-client" \
      --replace "python-gflags==2.0" "python-gflags"
  '';

  meta = with stdenv.lib; {
    description = "Command-line tool for interacting with Google Compute Engine";
    homepage = "https://cloud.google.com/compute/docs/gcutil/";
    license = licenses.asl20;
    maintainers = with maintainers; [ phreedom ];
  };

}
