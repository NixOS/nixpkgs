{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildAliyunSdkPackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "aliyun-python-sdk-${serviceName}";
      inherit version;
      pyproject = true;

      src = fetchPypi {
        pname = "aliyun-python-sdk-${serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [ aliyun-python-sdk-core ];

      # All components are stored in a mono repo
      doCheck = false;

      pythonImportsCheck = [ "aliyunsdk${toUnderscore serviceName}" ];

      meta = {
        description = "Module of Aliyun Python SDK (${serviceName})";
        homepage = "https://github.com/aliyun/aliyun-python-sdk";
        changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-${serviceName}/ChangeLog.txt";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [ fab ];
      };
    });

  # For packages where PyPI only provides a wheel (no sdist).
  buildAliyunSdkWheelPackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "aliyun-python-sdk-${serviceName}";
      inherit version;
      format = "wheel";

      src = fetchPypi {
        pname = "aliyun_python_sdk_${toUnderscore serviceName}";
        inherit version hash;
        format = "wheel";
      };

      dependencies = [ aliyun-python-sdk-core ];

      doCheck = false;

      pythonImportsCheck = [ "aliyunsdk${toUnderscore serviceName}" ];

      meta = {
        description = "Module of Aliyun Python SDK (${serviceName})";
        homepage = "https://github.com/aliyun/aliyun-python-sdk";
        changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-${serviceName}/ChangeLog.txt";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [ fab ];
      };
    });
in
{
  aliyun-python-sdk-actiontrail =
    buildAliyunSdkPackage "actiontrail" "2.2.0"
      "sha256-Vy4wSVKf1sIZdP0uT8mLBX0shcodkMojQlwiKI0mWjc=";

  aliyun-python-sdk-adb =
    buildAliyunSdkPackage "adb" "1.1.10"
      "sha256-kA1pYyBC0xQ4kAzAe2z43S2ADKyRmPFrhlXkLLaFqsc=";

  aliyun-python-sdk-adcp =
    buildAliyunSdkPackage "adcp" "1.0.0"
      "sha256-pG1G6sWiFWzz1HFW3pXkwopriSIrf3tDrRyLU48qGpM=";

  aliyun-python-sdk-address-purification =
    buildAliyunSdkPackage "address-purification" "1.0.1"
      "sha256-XD06C5i+OnoAAtJ4kYbHurPYhqAbtaf/iBmTOlEY4j0=";

  aliyun-python-sdk-aicontent =
    buildAliyunSdkPackage "aicontent" "1.0.1"
      "sha256-F0mrbd93CQMHxE7ZtmIZsvI2+7u2oc1YC6KajRdDyDg=";

  aliyun-python-sdk-aigen =
    buildAliyunSdkPackage "aigen" "1.0.0"
      "sha256-mF27O7EuNF28O0wUNT5x5IDhATZwAbwhDUF6BQy4zVs=";

  aliyun-python-sdk-aimath =
    buildAliyunSdkPackage "aimath" "1.0.1"
      "sha256-56R8dkl93Rqq3lzgYnvJ4w/5fEz6z7v1xL0IhoOfGXE=";

  aliyun-python-sdk-aimiaobi =
    buildAliyunSdkPackage "aimiaobi" "1.0.0"
      "sha256-2Fug1f5NztU6NNXfXaPpUnsOW+ZTQj9pMSwpdKh6eRY=";

  aliyun-python-sdk-aipodcast =
    buildAliyunSdkPackage "aipodcast" "1.0.2"
      "sha256-7RwUx8TQGzQbJo1HUA0j4yX2QibQqyS24JffOBxnypk=";

  aliyun-python-sdk-airec =
    buildAliyunSdkPackage "airec" "2.1.0"
      "sha256-yuCxxAi28yHQj+dNodzVHfhxC1JzUNll+qArZmbsbjM=";

  aliyun-python-sdk-airticketopen =
    buildAliyunSdkPackage "airticketopen" "3.0.3"
      "sha256-j1YvQSD91LSs4IpgDBrIfhSbJrG5iwH1f9e/sep+nV4=";

  aliyun-python-sdk-alb =
    buildAliyunSdkPackage "alb" "1.0.22"
      "sha256-1bvfyq8Xp4A0qikF32zKX/97pMdiVdqLkG5IxXBi1Xk=";

  aliyun-python-sdk-alidns =
    buildAliyunSdkPackage "alidns" "3.0.7"
      "sha256-HTALp6D84G+/jvYU02SlqLfv5LAM2Ju7fXm0JvpY4qs=";

  aliyun-python-sdk-alikafka =
    buildAliyunSdkPackage "alikafka" "1.0.6"
      "sha256-tNwf1vEuqiXFtIojr2k0wcJY5om7PHJalIPf3spFA6E=";

  aliyun-python-sdk-alimt =
    buildAliyunSdkPackage "alimt" "3.2.0"
      "sha256-oz8PNY/j6xE7pY91F8O5ed2j02q8tFl1A/u9Q5fYbuA=";

  aliyun-python-sdk-alinlp =
    buildAliyunSdkPackage "alinlp" "1.0.24"
      "sha256-7heBFMWyy5APuQW+Ao3XHChdsyQJtn29PxKmB83t8JI=";

  aliyun-python-sdk-amqp-open =
    buildAliyunSdkPackage "amqp-open" "1.1.4"
      "sha256-lcRVAP67FDxkCnw64eAj+kGPunx5uOP6PaKtoxCfO8Q=";

  aliyun-python-sdk-antiddos-public =
    buildAliyunSdkPackage "antiddos-public" "2.0.4"
      "sha256-+njm+bW/QRmH9+aaWaR4rRQDvhJ6WAnNb5nsfXgj9aw=";

  aliyun-python-sdk-anytrans =
    buildAliyunSdkWheelPackage "anytrans" "1.0.2"
      "sha256-hH2JzmOk63BqT9cKYyZObEZumKukNO3gnCQ+IjVU0wY=";

  aliyun-python-sdk-apds =
    buildAliyunSdkPackage "apds" "1.0.0"
      "sha256-tGVgh0IwA6zZ9wS+YLXLOCn4lSz2YzhPY8ImqsAQVbs=";

  aliyun-python-sdk-appstream-center =
    buildAliyunSdkPackage "appstream-center" "1.0.1"
      "sha256-7CH8NgQWf2yLZViCe0JTT/J7CwtDnN2LpXnbelQa1sg=";

  aliyun-python-sdk-aps =
    buildAliyunSdkPackage "aps" "1.0.0"
      "sha256-HPpvtr1/5C9ZgS7MvoTyoSyT/EqmmIvFfDZIA8LbOiA=";

  aliyun-python-sdk-arms =
    buildAliyunSdkPackage "arms" "2.7.32"
      "sha256-cLeR+eiIxH4bNQkTIyd+ZfXsNdPPpgqhi/2ViNSzKPw=";

  aliyun-python-sdk-avatar =
    buildAliyunSdkPackage "avatar" "2.0.8"
      "sha256-ctlhWz6yhHBfcwREjlw6QTieZyCd1KsBbxWP/Uw3aOU=";

  aliyun-python-sdk-bailianchatbot =
    buildAliyunSdkPackage "bailianchatbot" "1.0.1"
      "sha256-hdJZ8MYVKcc1JKnJT/uoO+L0MgVs19IUagboKmsv5QE=";

  aliyun-python-sdk-beian =
    buildAliyunSdkPackage "beian" "1.0.1"
      "sha256-9eKfNuQkRqY01/2MIr6OxqfGF/a+FqCnn2PW0n4/H90=";

  aliyun-python-sdk-bpstudio =
    buildAliyunSdkPackage "bpstudio" "1.0.18"
      "sha256-YnW4m0pYqBLjhmD7RI+SLccnkAmt0RlnqwcuwCcIxcI=";

  aliyun-python-sdk-brain-industrial =
    buildAliyunSdkPackage "brain-industrial" "1.0.4"
      "sha256-h1vShnxQSLOCsOyaNCtZsrCXC4Ft5zazF8EcqIlpqhc=";

  aliyun-python-sdk-brinekingdom =
    buildAliyunSdkPackage "brinekingdom" "1.0.7"
      "sha256-EhMCE7ogBsdY7RBlfn5OLg5UeFCdZ2sTbNRSzpnEna0=";

  aliyun-python-sdk-bssopenapi =
    buildAliyunSdkPackage "bssopenapi" "2.0.3"
      "sha256-DNMKpSGtcU3BxIunLLnb8if9gA+s1n5goX0VrFhOrx8=";

  aliyun-python-sdk-btripopen =
    buildAliyunSdkPackage "btripopen" "1.0.0"
      "sha256-ILmibOB6dERwn9t6M/xu49wt0FFdlR2Y9/u/Jrd+/Pg=";

  aliyun-python-sdk-buss =
    buildAliyunSdkPackage "buss" "1.0.0"
      "sha256-lj2u4ftBUrCUCklBOBM57MJ9XnMt/1ALAhcHE4nUdko=";

  aliyun-python-sdk-cams =
    buildAliyunSdkPackage "cams" "1.0.13"
      "sha256-LPnaGIssJ5nfQFYsne68V3Ltn9Su6LRyWxp4tRjyRmM=";

  aliyun-python-sdk-captcha =
    buildAliyunSdkPackage "captcha" "1.0.0"
      "sha256-5LlmBHJIPoXrbcZCzWBFWBVEu1AoU6oUuStQADvljIc=";

  aliyun-python-sdk-cassandra =
    buildAliyunSdkPackage "cassandra" "1.0.7"
      "sha256-3g74hm2rVr7dDCrSllHrwL/HLQnScfiJ8kzXCeYuEtg=";

  aliyun-python-sdk-cbn =
    buildAliyunSdkWheelPackage "cbn" "1.0.42"
      "sha256-HfgV8PmKNtL8nVYbCgtMjZMwfT4txRgy5n90i7zSW0c=";

  aliyun-python-sdk-cc5g =
    buildAliyunSdkPackage "cc5g" "1.0.7"
      "sha256-aFlUYAsBmsqsI+NtXenk/SKI97sih5JzwSfI365hKFM=";

  aliyun-python-sdk-ccc =
    buildAliyunSdkPackage "ccc" "2.10.3"
      "sha256-JrsR3q3bLXxBOf4qGmd+Yuk+ZEgQMJqj3VKuN672WUE=";

  aliyun-python-sdk-cciotgw =
    buildAliyunSdkPackage "cciotgw" "1.0.1"
      "sha256-koDpm9ziNfBmb2ur01HkrOtyeHzqQjvnXclUZQHvz0E=";

  aliyun-python-sdk-cdn =
    buildAliyunSdkPackage "cdn" "3.8.8"
      "sha256-LMCNvjV85TvdSM0OXean4dPzAiV8apVdRLTvUISOKec=";

  aliyun-python-sdk-cdrs =
    buildAliyunSdkPackage "cdrs" "1.0.9"
      "sha256-ccPl0gfTjYbHfFQ+Mdn5VXiFSwWj+thc0uvAPAi96P4=";

  aliyun-python-sdk-ciomarketpop =
    buildAliyunSdkPackage "ciomarketpop" "1.0.0"
      "sha256-vg04ZrV8LK7Om+uO0al9Ttm4aF81n2y5RtZXOQ4BUY0=";

  aliyun-python-sdk-clickhouse =
    buildAliyunSdkPackage "clickhouse" "3.1.6"
      "sha256-GjYzErL/18ND5KRz0PQ/dihSm2ekAoxy2ZrXymHKGxI=";

  aliyun-python-sdk-cloudapi =
    buildAliyunSdkPackage "cloudapi" "4.9.2"
      "sha256-+K9dZP7gpF9bB7jBoBsZ1xbPix6S06ly47ttZl3RX4w=";

  aliyun-python-sdk-cloudauth =
    buildAliyunSdkPackage "cloudauth" "2.0.36"
      "sha256-L8pem641eJ9N4WkL580RkwTYtOgbXYP2L6h8yh2uUwU=";

  aliyun-python-sdk-cloudauth-console =
    buildAliyunSdkPackage "cloudauth-console" "2.0.0"
      "sha256-+t/O2SXtc4/Yeowu3kGF0U/hv2HT3AYRwGwjE2KmjyM=";

  aliyun-python-sdk-cloudesl =
    buildAliyunSdkPackage "cloudesl" "2.1.1"
      "sha256-txrtPxFUd8QJ3S3EKd2BlDwKu2Bx98gWIomCqzo64lk=";

  aliyun-python-sdk-cloudphone =
    buildAliyunSdkPackage "cloudphone" "1.0.1"
      "sha256-hBkCsR4/aLE1wy+GlpwfzforIBtDG/UaI78lJZkU7Zg=";

  aliyun-python-sdk-cloud-siem =
    buildAliyunSdkWheelPackage "cloud-siem" "1.0.5"
      "sha256-dSkIuxH+PVqpdp5lp5BQQYdG/UPxBGd4yL1xfjFCkKU=";

  aliyun-python-sdk-cms =
    buildAliyunSdkPackage "cms" "7.0.33"
      "sha256-QWZbqyVT16xHHmv8QIpUJE8FARQToVYO+X3e1hXhDdQ=";

  aliyun-python-sdk-codeup =
    buildAliyunSdkPackage "codeup" "0.1.3"
      "sha256-oB8r6NwyhW9hjNV5HmMWQnXfICikjRVLm2/Zo/tuGeU=";

  aliyun-python-sdk-companyreg =
    buildAliyunSdkPackage "companyreg" "2.2.5"
      "sha256-7qSl9rHX4yonSeMhBS4qImCYBnlcSVqNlM6tPWiOOUk=";

  aliyun-python-sdk-computenest =
    buildAliyunSdkPackage "computenest" "1.0.3"
      "sha256-ogHH0oyU+tAimj6kQULwxjPo++WgAiW7gK7jE5kgPAk=";

  aliyun-python-sdk-computenestsupplier =
    buildAliyunSdkPackage "computenestsupplier" "1.0.6"
      "sha256-iKLLrwUinchFuHmUwbKkyXUWasIxL2s/GnSJrjAJsqc=";

  aliyun-python-sdk-config =
    buildAliyunSdkPackage "config" "2.2.14"
      "sha256-drmk41/k/JJ6Zs6MrnMQa7xwpkO7MZEaSeyfm2QimKo=";

  aliyun-python-sdk-csas =
    buildAliyunSdkPackage "csas" "1.0.11"
      "sha256-wcJLPRWbteUQqiANGUxUAJL8szPB+9IcN/0HGvZ0PKo=";

  aliyun-python-sdk-das =
    buildAliyunSdkPackage "das" "2.0.36"
      "sha256-iFt41fwlZWpvT4DcKQs+xVmKNFNEmPyO9OHgLmIc5mg=";

  aliyun-python-sdk-dashdeviceconsole =
    buildAliyunSdkPackage "dashdeviceconsole" "1.0.1"
      "sha256-VBKkH3YOi1Cph02099Ogeoy9JVU7eaWtPCRXkiBCXZc=";

  aliyun-python-sdk-dataphin-public =
    buildAliyunSdkWheelPackage "dataphin-public" "1.0.14"
      "sha256-GUAhGLGtwELUfuTGMuobCzzoRZJRbn9K7lzCAn4IYWE=";

  aliyun-python-sdk-dataworks-public =
    buildAliyunSdkPackage "dataworks-public" "6.1.12"
      "sha256-FSA3ICoJZCoRvHnM3wlgzgk7Zshaq1SxYdVib8avl1Q=";

  aliyun-python-sdk-dbfs =
    buildAliyunSdkPackage "dbfs" "2.0.7"
      "sha256-Kj6DfnXZq5ilE+vnZrAoZEhPDoNrMIs5p2OcBc24qXM=";

  aliyun-python-sdk-dbs =
    buildAliyunSdkPackage "dbs" "1.0.36"
      "sha256-Mx556g1xcHFMag69A48ChN1FLTj7SphaygNbWIpqPhw=";

  aliyun-python-sdk-dcdn =
    buildAliyunSdkPackage "dcdn" "2.2.19"
      "sha256-FsqccoBXdmN+utqxQJ9ujteCBoYT14kM+jJVZTeAJaA=";

  aliyun-python-sdk-ddosbgp =
    buildAliyunSdkPackage "ddosbgp" "1.0.1"
      "sha256-nuATkn0Ci4tLaslkBMDKZuaiBCvL6uz3V9lOw46Z4VY=";

  aliyun-python-sdk-ddoscoo =
    buildAliyunSdkPackage "ddoscoo" "1.0.6"
      "sha256-ySKys/ninfFq4bBOhXsfg/WhRxS57CWPu0a15apd9xo=";

  aliyun-python-sdk-ddosdiversion =
    buildAliyunSdkPackage "ddosdiversion" "1.0.0"
      "sha256-L2D2bOk2p2ldr31PCeHw0h6Dx8Ns/GZ8AXJmCfPARdg=";

  aliyun-python-sdk-dds =
    buildAliyunSdkWheelPackage "dds" "3.7.25"
      "sha256-XIMps9Tpi63zbJ6jViDHXF9zGmbtU1zI2ecOYJ58agk=";

  aliyun-python-sdk-devops-rdc =
    buildAliyunSdkPackage "devops-rdc" "2.0.2"
      "sha256-B0WSi04u1FnHeCrckrdiqan9+kJGV0Q+D96ql8IuTyw=";

  aliyun-python-sdk-dfs =
    buildAliyunSdkPackage "dfs" "0.0.2"
      "sha256-S8H0Qvr6NL6CarPrV5tac6cOQYoLyJMcrWaJ8X88KSQ=";

  aliyun-python-sdk-dg =
    buildAliyunSdkPackage "dg" "1.0.10"
      "sha256-n1Wl3vkKvoC4PCc791T/eOGDGF3DBduzATix3FH+D7s=";

  aliyun-python-sdk-dms =
    buildAliyunSdkPackage "dms" "1.0.0"
      "sha256-4hKNUwOQlxlTo0/mZUc0nCgY/AHhRZ5Iulw+lDz0i7Y=";

  aliyun-python-sdk-dms-dg =
    buildAliyunSdkPackage "dms-dg" "1.0.0"
      "sha256-KfifVG8I4kHfkzlkMpGkSaxo+pFyLnYKtl6p6oNMiHU=";

  aliyun-python-sdk-dms-enterprise =
    buildAliyunSdkPackage "dms-enterprise" "1.53.12"
      "sha256-3SPn/q/ghN1X1OUFIkNyrXQjg240wn9EhJjo4eHW+0g=";

  aliyun-python-sdk-documentautoml =
    buildAliyunSdkPackage "documentautoml" "1.0.0"
      "sha256-Ug07itDQtsOqDwM8eL+5HI04YY3GBIndAEL1ZCVwCrI=";

  aliyun-python-sdk-domain =
    buildAliyunSdkPackage "domain" "3.14.11"
      "sha256-wCzqn0OHukreS4EDdNPD36ogTy9+kzauHf5kl9jX02Q=";

  aliyun-python-sdk-drds =
    buildAliyunSdkPackage "drds" "20210523.0.2"
      "sha256-ASkvIPCzUi7pflSqfD79+WSG4ZtcFjodoSCZAXdZKrU=";

  aliyun-python-sdk-dt-oc-info =
    buildAliyunSdkPackage "dt-oc-info" "1.0.0"
      "sha256-NlLiCId3vMKn6oO1qh3IBN2CSVK/GTkkF71qtxgCdHw=";

  aliyun-python-sdk-dts =
    buildAliyunSdkPackage "dts" "5.1.29"
      "sha256-3D8azWnZ4B0grFNA5uJlQyh/GhVkxrBXr7hhnIGjDOw=";

  aliyun-python-sdk-dybaseapi =
    buildAliyunSdkPackage "dybaseapi" "1.0.8"
      "sha256-HbFMIRi3xnPy/lEw6l67r6AEQAjNbwZ8I10zieFfVIo=";

  aliyun-python-sdk-dyplsapi =
    buildAliyunSdkPackage "dyplsapi" "1.3.5"
      "sha256-Cw+LluwjTjwLdNieN4HYm4f6nAG+VGFwHtPrga+IjkM=";

  aliyun-python-sdk-dypnsapi =
    buildAliyunSdkPackage "dypnsapi" "1.1.13"
      "sha256-DmOGKDqG0n7pCjJU+G3NpQtSdW4gOMQytSg8Oyn/e8c=";

  aliyun-python-sdk-dypnsapi-intl =
    buildAliyunSdkPackage "dypnsapi-intl" "1.0.0"
      "sha256-kPHOb3uq1AcaXSvue6C92Pco3ef2aofEXzrgGBm3NpQ=";

  aliyun-python-sdk-dysmsapi =
    buildAliyunSdkPackage "dysmsapi" "2.1.2"
      "sha256-yZsEFwuhLcGLKVI1RxQKR1Hpr8FiW2aE5Prne7SuLFo=";

  aliyun-python-sdk-dytnsapi =
    buildAliyunSdkPackage "dytnsapi" "1.1.8"
      "sha256-VvvxHG2GFO5kl3EdfC8jIcPXuEcTjoY/3VL597duybQ=";

  aliyun-python-sdk-dyvmsapi =
    buildAliyunSdkPackage "dyvmsapi" "3.2.0"
      "sha256-U7uCrmD/dlbymSiEsGLwQslgO93+vUKdWBTZsNRcfy8=";

  aliyun-python-sdk-eais =
    buildAliyunSdkPackage "eais" "2.1.7"
      "sha256-BgRAs+AVPRi3HVWQCSpy62P3wzlVJliyvTA3o4/N6vY=";

  aliyun-python-sdk-eas =
    buildAliyunSdkPackage "eas" "0.0.9"
      "sha256-NX/FqXMgqpYwWer42MLKopHum6StHiXS/6XHYVJ0wec=";

  aliyun-python-sdk-ebs =
    buildAliyunSdkPackage "ebs" "1.3.7"
      "sha256-vrie1h9SHxC1QU/aIyvXS7UVDnOEiDjcArOrtTFu3kY=";

  aliyun-python-sdk-ecd =
    buildAliyunSdkPackage "ecd" "1.0.2"
      "sha256-VCEQSWdglWzjUsGOFIwpok4AzzQwKc/ld5lCDNcDaOw=";

  aliyun-python-sdk-eci =
    buildAliyunSdkPackage "eci" "1.3.3"
      "sha256-eV/bRJt1pOrfQvfFUQ6zwLgDZF33JK6KwE+/r9eH0JE=";

  aliyun-python-sdk-ecs =
    buildAliyunSdkWheelPackage "ecs" "4.24.83"
      "sha256-6ey1zhxJqq1IJd4hPjRwpPTRDQ2mVqpMvyiDZHi+yTo=";

  aliyun-python-sdk-ecs-workbench =
    buildAliyunSdkPackage "ecs-workbench" "1.0.4"
      "sha256-uPjwDavAcgBpBpiwpMB9arEVBoZv4PhZfTwP9BK+jXA=";

  aliyun-python-sdk-edas =
    buildAliyunSdkPackage "edas" "3.26.9"
      "sha256-oyudHqnZ67WBUGgDM2qtO4Q5r1kf6uiV1VOhKEVCCeQ=";

  aliyun-python-sdk-eds-user =
    buildAliyunSdkWheelPackage "eds-user" "1.0.4"
      "sha256-1j3WewECT811IK9+TY4XuTf+4PWV4Z+BSDrNy4AS8vA=";

  aliyun-python-sdk-eduinterpreting =
    buildAliyunSdkPackage "eduinterpreting" "1.0.2"
      "sha256-YXtaJmYsoans3DsszLWlIHA73UO9a/U3ce9RlHyNIW4=";

  aliyun-python-sdk-eflo =
    buildAliyunSdkWheelPackage "eflo" "1.0.19"
      "sha256-jMIaOMz1wQZf020Ziz2kKlPF3Hpq6aPfPPdwj+dxcB8=";

  aliyun-python-sdk-eflo-controller =
    buildAliyunSdkPackage "eflo-controller" "1.0.3"
      "sha256-YYeAwrk0XUJ1zzQSlYxv89HqG4EaeCxkIAyk/3NwzKQ=";

  aliyun-python-sdk-ehpc =
    buildAliyunSdkPackage "ehpc" "1.14.21"
      "sha256-KoARcIUKfnxqcwewesEc+GWn/Iu07jQ3dYULlQDwr+M=";

  aliyun-python-sdk-ehpcinstant =
    buildAliyunSdkPackage "ehpcinstant" "1.0.0"
      "sha256-fX05EMee3Vqg+nyJVZntd+QceEqAy0Jlm64SX/sQaUM=";

  aliyun-python-sdk-eiam =
    buildAliyunSdkWheelPackage "eiam" "1.0.5"
      "sha256-OvmC9PaYC7sKFoQ+JO1Ud5Y6hx9YVHerWZ9QLKvyb+M=";

  aliyun-python-sdk-eipanycast =
    buildAliyunSdkPackage "eipanycast" "1.0.5"
      "sha256-nMALy2b2TryKdEMN9nVls1G8CVFoGTeB3F4aXup9aVQ=";

  aliyun-python-sdk-elasticsearch =
    buildAliyunSdkPackage "elasticsearch" "3.1.2"
      "sha256-qIRwhElBpICkWH+QqOxaFwRyPOIINgPnDsXIxz1epes=";

  aliyun-python-sdk-emas-appmonitor =
    buildAliyunSdkPackage "emas-appmonitor" "1.2.0"
      "sha256-jNpDdapL65IUFlC2kHFlZjaEZ7pQjX+eCx3BCj2ffzw=";

  aliyun-python-sdk-emr =
    buildAliyunSdkPackage "emr" "3.3.10"
      "sha256-zCn0oYZB/Mav7CAmiezokeuylkDdm2tSVbek26hAqGA=";

  aliyun-python-sdk-emrstudio =
    buildAliyunSdkPackage "emrstudio" "1.0.0"
      "sha256-zxoAVxI7fhFJnItUKG8NGM96nHZxEJijTQ187RtFvBA=";

  aliyun-python-sdk-ens =
    buildAliyunSdkPackage "ens" "3.0.23"
      "sha256-s9qNHbsOITb8/tEsKtHpmuIRBCUk2v77Gj1lhSaqep8=";

  aliyun-python-sdk-esa =
    buildAliyunSdkPackage "esa" "1.0.0"
      "sha256-zkonVNChsFg2XWYt8AHFj6rRNwd019IGaex759OwBDo=";

  aliyun-python-sdk-ess =
    buildAliyunSdkPackage "ess" "2.3.32"
      "sha256-5MC/wnt2w7cgV+7WSzGOEWL77V4VrAcRnKi5Qn6VRnE=";

  aliyun-python-sdk-es-serverless =
    buildAliyunSdkPackage "es-serverless" "1.0.0"
      "sha256-GTwMtgqElNgmhN5n/2rGsWgvCZ/8oEoYD0TLTYtgRLI=";

  aliyun-python-sdk-et-industry-openapi =
    buildAliyunSdkPackage "et-industry-openapi" "3.6"
      "sha256-XIG+IsoPmGaFNQMDasgUcwjzcoPq767WEzk05BpnQAI=";

  aliyun-python-sdk-eventbridge =
    buildAliyunSdkPackage "eventbridge" "1.0.14"
      "sha256-Fz8RJv8dxTvXuweUtbYzq7ywjccLoR/07JHMX0C+xtg=";

  aliyun-python-sdk-facebody =
    buildAliyunSdkPackage "facebody" "2.0.14"
      "sha256-HMwao+oLdhd6RwdtTmG185WWSSJEtqEg1mwN2RLIcJ8=";

  aliyun-python-sdk-fnf =
    buildAliyunSdkPackage "fnf" "1.8.3"
      "sha256-hVzDwcUB3BHFc7k2d6/9rXbFT3c1vWy6ZZTcwBj6mHg=";

  aliyun-python-sdk-foas =
    buildAliyunSdkPackage "foas" "2.11.1"
      "sha256-k/ZWGk/EKT+nlO1K0TQN2SjDltrsbCJowdksIDafIoc=";

  aliyun-python-sdk-ft =
    buildAliyunSdkPackage "ft" "5.6.7"
      "sha256-XSAOP0UajrrBhcmkDo7OV07W2NPEQ9LqIrBVDgdhMyc=";

  aliyun-python-sdk-ga =
    buildAliyunSdkPackage "ga" "1.0.19"
      "sha256-QK3AsyglEY8SqAusVAAB+qXZNStjdn0gLl4T8WyFyNo=";

  aliyun-python-sdk-gdb =
    buildAliyunSdkPackage "gdb" "1.0.0"
      "sha256-jOw0DMRy8DEZHttvTmwDDgFot9hVDZu1cpbOS41fi4E=";

  aliyun-python-sdk-geoip =
    buildAliyunSdkPackage "geoip" "1.0.4"
      "sha256-CZTdvxa1NnFpmVizMJQVFaBD4ME1G1RNPHTkr48YeIw=";

  aliyun-python-sdk-governance =
    buildAliyunSdkPackage "governance" "1.0.0"
      "sha256-5u2+wauojKwLhWdcpsdqVN8pVXj04nJrt+/YZf1/cEM=";

  aliyun-python-sdk-gpdb =
    buildAliyunSdkPackage "gpdb" "1.1.7"
      "sha256-u8Er3yXaDsMyH0qz1dZhipX42knFJSqQiA7SiOG3LOI=";

  aliyun-python-sdk-grace =
    buildAliyunSdkPackage "grace" "1.0.0"
      "sha256-+ysYLgYcyFzVVXNLZaP+9UsjiofQZXGu/lN/vRsbwGE=";

  aliyun-python-sdk-green =
    buildAliyunSdkPackage "green" "3.6.6"
      "sha256-TifdOzViJiAvLA8Yd3HVEt8mhz76MZSegWUgtEg5Ris=";

  aliyun-python-sdk-gwlb =
    buildAliyunSdkPackage "gwlb" "1.0.2"
      "sha256-7xFUZWmmEIt+EodCom3OZUY1o9GkkG7gBKXHlGN7rDE=";

  aliyun-python-sdk-hbase =
    buildAliyunSdkPackage "hbase" "2.9.9"
      "sha256-nyiFzNP452MfNSbRnh7PDA5xo5d/npg2YEptb8iBP3E=";

  aliyun-python-sdk-hbr =
    buildAliyunSdkPackage "hbr" "1.2.10"
      "sha256-kQ4RXmX0AwjjoCjZKaJYwg+88D1bb9t90ayujmFFeow=";

  aliyun-python-sdk-hcs-mgw =
    buildAliyunSdkPackage "hcs-mgw" "1.0.0"
      "sha256-sBCozcE0FANK7Fjj8bm5sLa6bJwCXl0RO8NJQQivY3g=";

  aliyun-python-sdk-hitsdb =
    buildAliyunSdkPackage "hitsdb" "3.1.15"
      "sha256-D4j688DbjtsZA4PqINl19RCHEdY+oZivBBkAhnP6aqY=";

  aliyun-python-sdk-ice =
    buildAliyunSdkPackage "ice" "1.0.2"
      "sha256-HhKAKeWCcfBWdRgFXGzEkALNXV7BONEcTd5+2qHGVRU=";

  aliyun-python-sdk-idaas-doraemon =
    buildAliyunSdkPackage "idaas-doraemon" "1.0.1"
      "sha256-8RSnGSlRumFS3QXcWNZZaKzB69DKfiVPimrJrPoTnfY=";

  aliyun-python-sdk-imageaudit =
    buildAliyunSdkPackage "imageaudit" "1.0.9"
      "sha256-3GWmj/9ncPMdtF3KzsThJsnQ2aOp4IX6Y3iJ5u+uMho=";

  aliyun-python-sdk-imageenhan =
    buildAliyunSdkPackage "imageenhan" "1.1.12"
      "sha256-bJ58qSpDpKxGbrzGgD7plZBBTLitRfNBUrJ9562/DLo=";

  aliyun-python-sdk-imageprocess =
    buildAliyunSdkPackage "imageprocess" "2.0.7"
      "sha256-jtf2xu6C1hSBFobOVj+KYxLj6NlbPnE6yg1E8tRiS7U=";

  aliyun-python-sdk-imagerecog =
    buildAliyunSdkPackage "imagerecog" "1.0.19"
      "sha256-BjLZ5E1Om1adGs9W99DJ+pG/rRU0eI1ngoPOE2FXcpg=";

  aliyun-python-sdk-imageseg =
    buildAliyunSdkPackage "imageseg" "1.1.14"
      "sha256-MwZmcYqMiloi4ndTZznjnKHg2/pqAEQVeSSwfVSwXdc=";

  aliyun-python-sdk-imarketing =
    buildAliyunSdkPackage "imarketing" "5.0.2"
      "sha256-FwreXgR1ToR/RZxeLCjgEi1AFR9LTgLo/tLtRdLzYag=";

  aliyun-python-sdk-imgsearch =
    buildAliyunSdkPackage "imgsearch" "1.1.7"
      "sha256-BJ/1s6rJ4hrBMkFJg//XXtPN/9VgO2s795tcU7F0loM=";

  aliyun-python-sdk-imm =
    buildAliyunSdkPackage "imm" "2.1.17"
      "sha256-kYfJrmwKBzLwtQ/7QR+SmygIZT2i9F4yvA5Bsy9Wpjw=";

  aliyun-python-sdk-intlmarket =
    buildAliyunSdkPackage "intlmarket" "1.0.0"
      "sha256-Rwps1HLqvqoNOstm3u5XpZJ+vfbefogXRP61XGSdK8Q=";

  aliyun-python-sdk-iot =
    buildAliyunSdkPackage "iot" "8.59.0"
      "sha256-v0jTMKtYrbEBVjHQokpWSlcJBALZFsuoYHq8wCP8w1E=";

  aliyun-python-sdk-iotcc =
    buildAliyunSdkPackage "iotcc" "2.0.7"
      "sha256-kXgLpU2WDoj6NFRovif2GoEWsY5HP5bIEfe0Jx8vPvU=";

  aliyun-python-sdk-iqs =
    buildAliyunSdkPackage "iqs" "1.0.0"
      "sha256-V25LxLGU/2Epat/OPzO68qwyUEKOA4mWsH/WmgBndQM=";

  aliyun-python-sdk-itag =
    buildAliyunSdkPackage "itag" "1.0.0"
      "sha256-KRFUvvq711zk9RVOZ0yr1EUkVhJtHgsg0kQKQQAswU8=";

  aliyun-python-sdk-ivision =
    buildAliyunSdkPackage "ivision" "1.2.1"
      "sha256-uCsU9Uaw/2HxnoZmuyolPyM7ZnWDLS+rufU4W/Ikor8=";

  aliyun-python-sdk-kms =
    buildAliyunSdkPackage "kms" "2.16.5"
      "sha256-8yiooZ2D7LuWX/zg7B6ZMHVSFtEEY4zZXs02J1O4E7M=";

  aliyun-python-sdk-lingmou =
    buildAliyunSdkPackage "lingmou" "1.0.1"
      "sha256-4YVmlXorroQoinC5Jum1/JU0ucQ4gIPBy0JDtHGsd/k=";

  aliyun-python-sdk-linkvisual =
    buildAliyunSdkPackage "linkvisual" "1.5.8"
      "sha256-blZOKkpWFTc0ymT1T4uZjiS2KXTQGV1p2248wjVSetY=";

  aliyun-python-sdk-linkwan =
    buildAliyunSdkPackage "linkwan" "1.0.4"
      "sha256-2/7hNZjJMBr4w9WNH2wUMiRFHMjhcGPhvEE2sqyd69A=";

  aliyun-python-sdk-live =
    buildAliyunSdkWheelPackage "live" "3.9.75"
      "sha256-XrR7cw1POAgo1wnKQBCpKPzmNWEEF0/7xItuNob5uD0=";

  aliyun-python-sdk-ltl =
    buildAliyunSdkPackage "ltl" "1.0.0"
      "sha256-Vv4hDMmt9y3+Gu3IecKkv/xKYIi0PSy50Kgenty9PYk=";

  aliyun-python-sdk-lto =
    buildAliyunSdkPackage "lto" "1.0.0"
      "sha256-R51rXfKnIJSr0Yb6g/ru9Ex7ur7gjBx58ue0UlyqmfU=";

  aliyun-python-sdk-market =
    buildAliyunSdkPackage "market" "2.0.24"
      "sha256-0aO7EUjvVLa9kHH0C8WyC+vwxPyCEu0iCrmiYHhGH4I=";

  aliyun-python-sdk-marketplaceintl =
    buildAliyunSdkPackage "marketplaceintl" "1.0.0"
      "sha256-i/+hBF6VWWxGf9LiDp6wTG19aLJBrc4sX7uzAfAuUAU=";

  aliyun-python-sdk-maxcompute =
    buildAliyunSdkPackage "maxcompute" "1.0.3"
      "sha256-ZajrA1MMP72LT9Y2xW0q+cPDwbp2EyuTcwc5uh2Wqrs=";

  aliyun-python-sdk-mns-open =
    buildAliyunSdkPackage "mns-open" "1.0.2"
      "sha256-9i65Vcs4VhDPFMZwHGLBMjrH/Wu/pYd686QODTGX4ng=";

  aliyun-python-sdk-moguan-sdk =
    buildAliyunSdkPackage "moguan-sdk" "1.1.0"
      "sha256-e5CLXCeZc8zmc4f7tfAlz+74I/wqAD71k3ik6yo7KaQ=";

  aliyun-python-sdk-msccommonquery =
    buildAliyunSdkPackage "msccommonquery" "0.0.1"
      "sha256-W9/ZiVDSTwvtSX4jRuZjN04ibEx1yVcPN9v+Bm4CJiI=";

  aliyun-python-sdk-mse =
    buildAliyunSdkPackage "mse" "3.0.24"
      "sha256-PcjDrKJBDT0oAz8FFW4HJ3cV1z2pvcCpxx+eRzWh9ew=";

  aliyun-python-sdk-mseap =
    buildAliyunSdkPackage "mseap" "1.0.4"
      "sha256-CBYnH7gGaXvRP6Vpa6Xk4YFvK7vd6Ahosfv1wqrXza0=";

  aliyun-python-sdk-mts =
    buildAliyunSdkWheelPackage "mts" "3.3.46"
      "sha256-73cn+UWmmtsZZDh+lDbDgwZpZcfb/Qq4iOQpwhAGlxE=";

  aliyun-python-sdk-nas =
    buildAliyunSdkWheelPackage "nas" "3.14.5"
      "sha256-VGGauutVaDgoiHq+T+gH+k3seHZ+l4vO1GJXnZAJjpQ=";

  aliyun-python-sdk-nis =
    buildAliyunSdkPackage "nis" "1.0.2"
      "sha256-m+uYdGL2KY7qG1HskcI/oSSLu76bB8Tb0OQyCRXELFc=";

  aliyun-python-sdk-nlb =
    buildAliyunSdkPackage "nlb" "1.0.12"
      "sha256-DmhrujQjY0HyV3SpJ2W0+600F4gYItikhO+iX+j9rXc=";

  aliyun-python-sdk-nlp-automl =
    buildAliyunSdkPackage "nlp-automl" "0.0.15"
      "sha256-9UrzkIOSFcbuYXVJrCFhUG1RNZVmj06we+KeTdrMIn0=";

  aliyun-python-sdk-objectdet =
    buildAliyunSdkPackage "objectdet" "1.0.16"
      "sha256-eVStbo/GokFnr5nY9fZNC3GXQ0T/MRuK8F6yYtQaHTs=";

  aliyun-python-sdk-oceanbasepro =
    buildAliyunSdkPackage "oceanbasepro" "1.0.31"
      "sha256-3CULwLpDIbCPdp9WYr2VNjf53PS/XtkEY2dNVGmDzVk=";

  aliyun-python-sdk-ocr =
    buildAliyunSdkPackage "ocr" "1.0.25"
      "sha256-5xny5tzz9bpnlbwS5+U4XYPgPwWhvn2euQ8cH5fnQpA=";

  aliyun-python-sdk-ocs =
    buildAliyunSdkPackage "ocs" "0.0.4"
      "sha256-Nho8LbAkWJTegGeDZjB973YUEyTWzjLrfxGaqYHT7AE=";

  aliyun-python-sdk-oms =
    buildAliyunSdkPackage "oms" "1.0.0"
      "sha256-A6M+T0xu4hKt+6mMgZvDDK1d5pGF5vZjxt8174jac9M=";

  aliyun-python-sdk-ons =
    buildAliyunSdkPackage "ons" "3.2.3"
      "sha256-hX9+U7/Z8wbn0CJ0y+BO3Y9sl4eOFt0/M+sEG+eu7AY=";

  aliyun-python-sdk-onsmqtt =
    buildAliyunSdkPackage "onsmqtt" "1.0.5"
      "sha256-j20bBm6JIlV40b4BVvrH++9AZ1I1wKCuaY2JctfXCWY=";

  aliyun-python-sdk-oos =
    buildAliyunSdkPackage "oos" "1.5.16"
      "sha256-8CocGErJCZYOEtPEwTQ+XgoY/lLgpLmfgB37nLk25yM=";

  aliyun-python-sdk-openanalytics-open =
    buildAliyunSdkPackage "openanalytics-open" "2.0.5"
      "sha256-um1fqWyp1kervEB954t3nUoJdD41cteGt8wAN2Qq0/Q=";

  aliyun-python-sdk-openitag =
    buildAliyunSdkPackage "openitag" "1.0.0"
      "sha256-/tnsRjUgGCRkO7M3KDCOsmdclBECdpYTRjDtwL08oyI=";

  aliyun-python-sdk-opensearch =
    buildAliyunSdkPackage "opensearch" "0.12.2"
      "sha256-kyJJt7UM3tbt88lJCa3JlbxsRcDMqMQi487dp+ouw+0=";

  aliyun-python-sdk-osssddp =
    buildAliyunSdkPackage "osssddp" "1.0.0"
      "sha256-z2TKT94A2lzXdZqLteuoZZLAua7HKtZ9dcWjySxjdss=";

  aliyun-python-sdk-outboundbot =
    buildAliyunSdkWheelPackage "outboundbot" "1.6.3"
      "sha256-nY3+SNpG90lFdRimn5r4SuyI6aPvLJEoZqJZ/j4/XRs=";

  aliyun-python-sdk-pai-dsw =
    buildAliyunSdkPackage "pai-dsw" "1.0.0"
      "sha256-htT9Pyz30aQg+KlGqK/QcfyuT3byF/AnV2L9PNyfsJY=";

  aliyun-python-sdk-paielasticdatasetaccelerator =
    buildAliyunSdkPackage "paielasticdatasetaccelerator" "1.0.3"
      "sha256-3ydKRQRmsFNThMdPGuW+yxF99olV5Le5AbVC9g1IRwc=";

  aliyun-python-sdk-paifeaturestore =
    buildAliyunSdkWheelPackage "paifeaturestore" "1.0.19"
      "sha256-jmltVn0J+PzMTXf8zA4RdYawHDFlMB3k5YcYX03ZF+Y=";

  aliyun-python-sdk-pairecservice =
    buildAliyunSdkPackage "pairecservice" "1.0.3"
      "sha256-4TGawz8GlXkoRt+wMejP4duejmk9iqfUpqFj/cfkSTE=";

  aliyun-python-sdk-polardb =
    buildAliyunSdkWheelPackage "polardb" "1.8.58"
      "sha256-JHXODBt9NcVTWjp+9EGFitkowhSYK3hb0/yB0XsXzvA=";

  aliyun-python-sdk-polardbx =
    buildAliyunSdkPackage "polardbx" "20201028"
      "sha256-rftRnOeKPYWGX9K9NC7gib6Yf8xVgQfg/lp/7PsGoKU=";

  aliyun-python-sdk-privatelink =
    buildAliyunSdkPackage "privatelink" "1.0.8"
      "sha256-zmEKxzMJ5+aVNN9ZRNXpYv6bXTBSbXUEwQlcw8DtHnY=";

  aliyun-python-sdk-push =
    buildAliyunSdkPackage "push" "3.13.21"
      "sha256-gxkHNOAy6dJmeB2QqugRlPyGe2JIhD/oCz+5nRSRbNg=";

  aliyun-python-sdk-pvtz =
    buildAliyunSdkPackage "pvtz" "1.3.0"
      "sha256-3I1oEDRGVI/O+yUQdN/dhHvmq0kXEvR4BdcpsrPJuUc=";

  aliyun-python-sdk-qianzhou =
    buildAliyunSdkPackage "qianzhou" "1.0.0"
      "sha256-Y3Ubzt5c6tIZqN3NbFCAPeEtcBZyBdVPDPXqNiT0pmg=";

  aliyun-python-sdk-qualitycheck =
    buildAliyunSdkPackage "qualitycheck" "4.7.1"
      "sha256-UG6zzsh1LFo9X/OPhZy0783vy4RneLCRqu0zBsIS+Yo=";

  aliyun-python-sdk-quickbi-public =
    buildAliyunSdkWheelPackage "quickbi-public" "2.1.20"
      "sha256-+/JyCEGZsfnfKrSyjh7JXIJM5ssIgZyf5orGrEHoPec=";

  aliyun-python-sdk-quotas =
    buildAliyunSdkPackage "quotas" "1.0.4"
      "sha256-oidX8n7QZXxlEqGySwEeIl5nI1bL0tcb1CSduXMO3Jk=";

  aliyun-python-sdk-ram =
    buildAliyunSdkPackage "ram" "3.3.1"
      "sha256-D9SC1XdnhizZ29bJkro8RCuOGZ1DvfKzNrXUGk7ceVc=";

  aliyun-python-sdk-rds =
    buildAliyunSdkPackage "rds" "2.7.53"
      "sha256-BXtNpOO2RUd+VwLf4BClqp7yG5a00N+L45XbOeCk3g4=";

  aliyun-python-sdk-rds-data =
    buildAliyunSdkPackage "rds-data" "1.0.0"
      "sha256-hbwR1Q0MXVLKkAC17GV9Ng+RWXKhPQdKMUDduwR7+n4=";

  aliyun-python-sdk-reid-cloud =
    buildAliyunSdkWheelPackage "reid-cloud" "1.2.2"
      "sha256-MeHA5T4UTME6YDLhcw1/7nYMsWnbFTOYiypWb1/sKj0=";

  aliyun-python-sdk-resourcecenter =
    buildAliyunSdkPackage "resourcecenter" "1.0.7"
      "sha256-ow1KULDKUPe33GTx6VLDw+n8PJK8MZOZVgiVANsqbes=";

  aliyun-python-sdk-resourcemanager =
    buildAliyunSdkPackage "resourcemanager" "1.2.7"
      "sha256-9qpRMmsiCk2mhzNixuPRgshpC9qRVt9Q+wOb32/nOfs=";

  aliyun-python-sdk-resourcesharing =
    buildAliyunSdkPackage "resourcesharing" "1.0.1"
      "sha256-bVxAcaG8MLl+9ws0WU/fsF2te9aV2rB6xrTWJycqHcY=";

  aliyun-python-sdk-retailcloud =
    buildAliyunSdkPackage "retailcloud" "2.0.20"
      "sha256-85xhtAahv6iQODUe1eXH/Kb7npUmu+IJ34JpAle+egY=";

  aliyun-python-sdk-r-kvstore =
    buildAliyunSdkWheelPackage "r-kvstore" "2.20.17"
      "sha256-TGu2Z/k809MSGPtKekyjKdwgpSbRPuqmMSKv5FDKgGg=";

  aliyun-python-sdk-ros =
    buildAliyunSdkWheelPackage "ros" "3.6.1"
      "sha256-60pZ+aKlvPvkvN2CCsgGuYyQ9irXjEnz6tD9zbzJchs=";

  aliyun-python-sdk-rsimganalys =
    buildAliyunSdkPackage "rsimganalys" "4.3.1"
      "sha256-hdbPPpXIkFNTz7GoEPF2OEX5uCnULnCiwyw2cQkEhmE=";

  aliyun-python-sdk-rtc =
    buildAliyunSdkPackage "rtc" "1.3.5"
      "sha256-s4R2hieFYfUOWC8CnH3z5F+ctJtRxgF7d5PJFp9nvUY=";

  aliyun-python-sdk-sae =
    buildAliyunSdkPackage "sae" "1.22.16"
      "sha256-ed8s3qqH3VcsYSjygOeBU586+WLqCWz4k4ll4mWfgV8=";

  aliyun-python-sdk-safconsole =
    buildAliyunSdkPackage "safconsole" "1.0.1"
      "sha256-eLFa0xt7u7rDd+Q73xva5dlR4RBWR++yJHctvrC4VCM=";

  aliyun-python-sdk-sas =
    buildAliyunSdkPackage "sas" "2.0.3"
      "sha256-3i+FIrBmJZk7Yij4DUitRwcyq8FnHxEDoLyBhk7h7rY=";

  aliyun-python-sdk-sasti =
    buildAliyunSdkPackage "sasti" "1.0.0"
      "sha256-APuN8zRIfWJT26taeei7iipqml1c5AJqqBhP5Xq64M8=";

  aliyun-python-sdk-scdn =
    buildAliyunSdkPackage "scdn" "2.2.9"
      "sha256-9IxJnw+Kyt6PLdiXCAKYOYQWXY4hNux+VBV43WhHjRs=";

  aliyun-python-sdk-schedulerx2 =
    buildAliyunSdkPackage "schedulerx2" "1.1.15"
      "sha256-0YOYHRkAsX6W7tdEYkoDASGfenx4MVkc59Zl9zein7w=";

  aliyun-python-sdk-schedulerx3 =
    buildAliyunSdkPackage "schedulerx3" "1.0.0"
      "sha256-A3w1FNyuXHF89arZb9LfbR1eDoNTC3M1CCstcbUUrxE=";

  aliyun-python-sdk-scsp =
    buildAliyunSdkPackage "scsp" "1.0.0"
      "sha256-/EhUmPTCL9WNflC7CJtejnkOIFtL316Qq1IesAoytHs=";

  aliyun-python-sdk-sddp =
    buildAliyunSdkPackage "sddp" "1.0.10"
      "sha256-117kEI1ajHktEWo7kAbqo8BCO6bisJCa37vmFUKOP3Y=";

  aliyun-python-sdk-selectdb =
    buildAliyunSdkPackage "selectdb" "1.0.0"
      "sha256-l6EprfJVijI2mhFogTmBqJlc3nNTmMAsdsQoq0fais0=";

  aliyun-python-sdk-sgw =
    buildAliyunSdkPackage "sgw" "1.0.4"
      "sha256-XrzjMwpWrOfM5lyIuSR+mP1MgtCGcyB4DH4QDGJlaro=";

  aliyun-python-sdk-slb =
    buildAliyunSdkPackage "slb" "3.3.22"
      "sha256-xvrMcLhY1QHEGxSmZ+jnApL/9Mq8notzQM+O0RPUe9g=";

  aliyun-python-sdk-sls =
    buildAliyunSdkPackage "sls" "1.1.2"
      "sha256-79zKRPvRP+oGvaUelmAz6/WBP8iYjemJU1zJPzAb7gI=";

  aliyun-python-sdk-smartag =
    buildAliyunSdkPackage "smartag" "2.0.4"
      "sha256-Go1afkSl0PtZUtj4sfiiK9Ayc2C+4k80NXq1RMqWus8=";

  aliyun-python-sdk-smartsales =
    buildAliyunSdkPackage "smartsales" "1.0.0"
      "sha256-AeYCWNxjjKEtwft1x5bKmYprPg20mBBZcWirswfK5pA=";

  aliyun-python-sdk-smc =
    buildAliyunSdkPackage "smc" "1.0.4"
      "sha256-cGWbBlrepDU4ZcsUzXiPZr3uY/jVAykU1p3s3QVSijE=";

  aliyun-python-sdk-snsuapi =
    buildAliyunSdkPackage "snsuapi" "1.7.1"
      "sha256-gEDulzmGBEeX4A8VL5XeSVS4PjSF+9dYs9R3SBlOixY=";

  aliyun-python-sdk-sophonsoar =
    buildAliyunSdkWheelPackage "sophonsoar" "1.0.1"
      "sha256-+90QDFwFVh6hpktaNxeA5pkPbb5UjN3nSoC0MsUUSks=";

  aliyun-python-sdk-sts =
    buildAliyunSdkPackage "sts" "3.1.3"
      "sha256-Iv7bi60T+WbnEaH0Zi7te52zNEG8BapLD5GKoB4JuWc=";

  aliyun-python-sdk-swas-open =
    buildAliyunSdkWheelPackage "swas-open" "1.0.14"
      "sha256-OX9aJgRE25fsbfHVT+EPppSjneGiKkLw7hJ67d2HUM4=";

  aliyun-python-sdk-tag =
    buildAliyunSdkPackage "tag" "1.0.6"
      "sha256-yvCSPp3NPmA6/EU8ZfJeHKB+8GckOXDusjGbyVyxJRM=";

  aliyun-python-sdk-threedvision =
    buildAliyunSdkPackage "threedvision" "1.0.4"
      "sha256-HLzum3x3lTEY+6Xq6cR33eBI3EqRVUnPTSW+k2I9Y/s=";

  aliyun-python-sdk-tingwu =
    buildAliyunSdkPackage "tingwu" "1.0.7"
      "sha256-7ytBiepU7WaiJuZZUNyzEx6jBA7g5EZzUo4GFowfApU=";

  aliyun-python-sdk-unimkt =
    buildAliyunSdkPackage "unimkt" "2.4.8"
      "sha256-GEWnH4X/Ia4+JRzUIZ8folr0S9Sduji7UL+riONwnG4=";

  aliyun-python-sdk-ververica =
    buildAliyunSdkPackage "ververica" "1.0.2"
      "sha256-Yphxd3ea9F0aIJXhphX2dt1TgWbOlLkZ8YzR8at8Kk4=";

  aliyun-python-sdk-viapi =
    buildAliyunSdkPackage "viapi" "1.0.0"
      "sha256-iWgIKfAxm1qu+CEG/6l1v0aUvekCNqTbNGeawz+LavU=";

  aliyun-python-sdk-viapi-oxs-cross =
    buildAliyunSdkPackage "viapi-oxs-cross" "1.0.0"
      "sha256-Jvk/w59tz/38ewhzLQuySVChBXi0GL2Gr3azqv1EZYc=";

  aliyun-python-sdk-viapi-regen =
    buildAliyunSdkPackage "viapi-regen" "1.0.4"
      "sha256-DzY354VlVaz5iCt8LfZtMlEsGe2XJ4UxXj1GhtHydnU=";

  aliyun-python-sdk-videoenhan =
    buildAliyunSdkPackage "videoenhan" "1.0.24"
      "sha256-TXqCmWdFI0nJdKrJAfwPI2HG3vZKxMMZI/PWiIu310E=";

  aliyun-python-sdk-videorecog =
    buildAliyunSdkPackage "videorecog" "1.0.9"
      "sha256-oG4xaUnu9oKj0WkBZJISRqEmpXqmY9zYYtp4THE2XpY=";

  aliyun-python-sdk-videoseg =
    buildAliyunSdkPackage "videoseg" "1.0.4"
      "sha256-VfiVkrojVajATTO9uuHS+YNXb19hiHHnq1INXaUnSR8=";

  aliyun-python-sdk-vod =
    buildAliyunSdkWheelPackage "vod" "2.16.32"
      "sha256-Gnfx0O+68jD6ZWhrpLW1ylNjriN6mTuD2btO/XkNf9I=";

  aliyun-python-sdk-voicenavigator =
    buildAliyunSdkPackage "voicenavigator" "1.7.0"
      "sha256-AH1ETCJY5Z1HQR7hF0Efcl1B1+1Tbsy0iR8giNDeGi0=";

  aliyun-python-sdk-vpc =
    buildAliyunSdkWheelPackage "vpc" "3.0.48"
      "sha256-s5FdKBu3XmsaI/CBQmch+pAutgb1gg3C+acc+nEMRuE=";

  aliyun-python-sdk-vpcpeer =
    buildAliyunSdkPackage "vpcpeer" "1.0.3"
      "sha256-RniPFzNXnWlkjoCxz8L9ffOu6NVWw49wSNhtoKV5Ot8=";

  aliyun-python-sdk-vs =
    buildAliyunSdkPackage "vs" "1.10.4"
      "sha256-sY9NbIctyDZ8XmtZhOccqY5NXMeRsk0FMtZecIu/mWE=";

  aliyun-python-sdk-waf-openapi =
    buildAliyunSdkPackage "waf-openapi" "1.1.10"
      "sha256-p43bVHBFdKGh8+4OU5PtuoFAQnNLRp1WISDMB23RzYE=";

  aliyun-python-sdk-websitebuild =
    buildAliyunSdkWheelPackage "websitebuild" "1.0.8"
      "sha256-ESCFQ3kt/BfPf+THkjWj4g5Bj9/WrJCj98Ht96liVsE=";

  aliyun-python-sdk-wfts =
    buildAliyunSdkPackage "wfts" "1.0.0"
      "sha256-V2kHxs5AFGF7i8MLkUZF32zBbU/MY98p8hy46XoEtB4=";

  aliyun-python-sdk-workbench-ide =
    buildAliyunSdkPackage "workbench-ide" "2.0.5"
      "sha256-Y1dHLXUTGkKaxMXLHlHzbqLrH0/kcXG1IDACKeyKahI=";

  aliyun-python-sdk-workorder =
    buildAliyunSdkPackage "workorder" "3.1.4"
      "sha256-BesoQV444cBAOAyVKa7y7rej67ABOcIiL33IdsZYmv0=";

  aliyun-python-sdk-wss =
    buildAliyunSdkPackage "wss" "1.0.1"
      "sha256-dZmvmKU0rBgvo66Lu78mtEGtBkjRp4K18Bw6YWBj0gI=";

  aliyun-python-sdk-xtrace =
    buildAliyunSdkPackage "xtrace" "0.2.2"
      "sha256-q3RGQd8C0IiM+TjottDv2laZ0Wrgs4bPfqDqYLyZy+s=";

}
