{
  lib,
  boto3,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildMypyBoto3Package =
    serviceName: version: hash:
    buildPythonPackage rec {
      pname = "mypy-boto3-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        pname = "mypy_boto3_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [ boto3 ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [ "mypy_boto3_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for boto3 ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [
          fab
          mbalatsko
        ];
      };
    };
in
rec {
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.37.0"
      "sha256-mm2NgDfVTGN4LqbUR0YJhMwmcsftMRpyg3QZNo/p2Ko=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.37.0"
      "sha256-jw5HNxl27fEtBEfkK4oHQICMtF8W91mKyU5lTlhCndc=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.37.0"
      "sha256-gsMMlrHbh6ngwsbRlSKXn5M9WnJ/x3n8wp1xeyCuZKs=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.37.0"
      "sha256-Wi7ObxF433J/tamCPrjyDefvARAl35suSR74foUS5ko=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.37.0"
      "sha256-rxpBCIXOkSl5UeP1e0Rz8VK4tU3qD7nqG77YiGTv/0U=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.37.0"
      "sha256-u3dXLZ2cSPWfOyzvWh/TtXaPz9Oaon3LqcQXhnEa67Q=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.37.0"
      "sha256-uLmvOXUQwovfh97MWlKIqJwey2oLffriJfKJS3YxnDM=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.37.0"
      "sha256-QDagskTiBtIbR8dIh5E3bdAxaezblNXWNEGGmNUcrWY=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.37.0"
      "sha256-VS0iDnBlRPV6KBDC198tkxECMC13W1jjujsmig174BE=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.37.0"
      "sha256-Y6BQWnf8h7ec2Rt4bhuyAl1KAIe53rnhTupcNeROQ8I=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.37.0"
      "sha256-vF9qDs4R1LCPpYjdRqSEmTB64rOTKToJjmKwHlwOkyc=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.37.0"
      "sha256-dXyky8lKmsgsiClukddDdKHAwu1V7dlD71WShhzYBJE=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.37.0"
      "sha256-RPLid9Y3w84UcTJoZaxOEX5Faghne85+JA+RhsJs2pw=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.37.0"
      "sha256-Cpfs4Z5ziJoW32uwFQNhwpj6uRCjURn30LGL+/iL/1w=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.37.0"
      "sha256-VRNuh0ldVT7I2Pml5WzJpz1yvs3K1hlMgHIpcFTGuuE=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.37.0"
      "sha256-tyUEvQdkjZZYaGytrQOK2TOGrhKlVikdxyECl6Zz57M=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.37.0"
      "sha256-lcpglldLcTNS22dpGNB/NnDt1CPOUAzwVdcWoRMzHyE=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.37.0"
      "sha256-2NYYxdpcfu21ZhCAuoTR1d0QihRCHM49Sb1nqfOHLgk=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.37.0"
      "sha256-hL42qeJXsW9DGu8Q8U5QEBJEHSa5WsneEk0obz9MHeY=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.37.0"
      "sha256-XqjSIzrwDJt/3sezSWzHAklsUuUttuBs6THG5ghvdow=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.37.0"
      "sha256-HNZHoep58nGU3b6e5s3X9RGBORJy6ogNT6Jbz0fNmOk=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.37.0"
      "sha256-v47OKnLvmkjv8+HBRlrv+wP+MIapoiz3HGplK6SEXGM=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.37.0"
      "sha256-KuiUFCfIcGHwIRrKsezOcGodrA3UrqdDPI3yl5Lpkmw=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.37.0"
      "sha256-3s+fYgf1gAy1o5V0uNrUcznLplweWm+2mTgMl4cmMWQ=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.37.0"
      "sha256-qBzg02M7akfgvbBeeg2T++ahv9cr712G+/3oyhU37Q8=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.37.0"
      "sha256-wH8zPvix4Yd0uBbz71EJmk6YWe/bBZz4v+QHjl2yud0=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.37.0"
      "sha256-C28bRk0IhJreEN0Zs/SfyBrhnvV12+Lbojp2oGJenfc=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.37.0"
      "sha256-cHLVZqOWxEFgselqi+XBqItepzP8hND1Ef7jHDOLdNU=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.37.0"
      "sha256-s4fJlVo+fCChHPX7YNaFVv7JHBfVegr9ce26VxVQ1v4=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.37.0"
      "sha256-SFybjQDlMxvgIFQbv/D6wDexm+s4u26I6Lj2T94vwak=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.37.2"
      "sha256-cEJJucCt54tLZBZKseJWFzW+baIoySP2igPcgfj7Ri0=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.37.0"
      "sha256-/SE9khiBMUq4oKpg58wUlIuauRerWWm40K3d/soRxv4=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.37.0"
      "sha256-qGK4daMp3zODuppGz335Or5hpggK6uTkbQqfXOKq6eM=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.37.0"
      "sha256-M1WWs/HMcN0L9qK2eu4x+JmZsvbEbmxZzQBkjU5gfh4=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.37.0"
      "sha256-nlk8Jb31LevHaTX8DwCv6H3h6CSQKzoBwXWDqgfqZa0=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.37.2"
      "sha256-3wXkwVzhm+4pU81/Z4EnLhbuvNJGQ6VIXY1HKqQ/BxE=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.37.0"
      "sha256-iGZ9RTkHEJwMWwr2n4+WMtl4RtLmhXT2wMXixx4Akek=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.37.0"
      "sha256-8mTGUxCx/HeIWtwj9mHejVRBMQSNjv8MeLdWTTpwA7Y=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.37.0"
      "sha256-k/OxG9pwEz+dUNohIHocantP82rho4C407lnaU9LA/8=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.37.0"
      "sha256-c7p/kch9H2Skn48ue8emfMkt5+mTmLZWEeuAuAhvX0w=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.37.0"
      "sha256-FINgDMmIhMn5M/qVGE3rzZJZEU121rDXNQYa39veAYk=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.37.0"
      "sha256-ovn/hkWHBBTUsDkQppzTApcVRYZXwxTOugZHIPnbCQk=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.37.0"
      "sha256-ihfdqDnLejO7jEpXp1UPzeOWZTk2RgCBDbSIYJsy0oU=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.37.0"
      "sha256-BmOYLQsJB84gWmOepiX/8D+E6iE9BXKSYJnvdrUOb7M=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.37.0"
      "sha256-lIkRuhQHTqlXRkyf9hIIZ0oh3vgdr5GzLApLt9lXvaw=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.37.0"
      "sha256-v8dLqGFGcUBuEfKEYJZ0FnUz7aIg3WNcL7gky2Ajuu0=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.37.2"
      "sha256-Gc4T9+rNmzlbo9yuV12iHfttGpLnC+kgJDLx3fBC11w=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.37.0"
      "sha256-TfXQ7WusMBtFnYahTsFUezH3WjwCZwi18ZfrdVQ6jpk=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.37.0"
      "sha256-qNrd2rqQOdp3KHc+qbFr7JipKYOTC6GYOIvZ1evaUD0=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.37.0"
      "sha256-UxNVDqlpS9Uuh50DTHmtWhcGNEyN2o2vdJ363JYikOE=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.37.0"
      "sha256-6tc2bij0RUtPFNgefY9R60Zh6mSEvWTYTWoaeNweNpg=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.37.0"
      "sha256-qBBsxvlXnJHiRrGUQFWMoEeIvLJsC8TVnV7UtBbSRWQ=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.37.0"
      "sha256-7pvwZiB49BKMjtIinH4mP9ANB/Lmz+t9lGDe4/npbkg=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.37.0"
      "sha256-opF62LDq9qj0vLpAUrSVSI1aTRtpSk3z2yiJtvUsnNI=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.37.0"
      "sha256-nVAeLXy2hjJZDjNTjFccKClY7DS0oLv9Q9QLlngkX6M=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.37.1"
      "sha256-8Z+3exV0XBznoiPVFcisI+8BP7HL5ZLxJ6NHUoD6lNU=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.37.0"
      "sha256-TlaHDYxzCGSqT0a6M6NeY2tQvzMofBdnIi/j7Ylc2Fc=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.37.0"
      "sha256-hg72Shw9ceqVqiuETPt6NNnvR7WaASg6CJLI2nfRV20=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.37.0"
      "sha256-J8Gj/NH17QlI6rfqt4kdp+FhW3n+KNp+vTA3Wevs2Lk=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.37.0"
      "sha256-rCeCZ4BgNHxS9Su5nh/Ho8Ka2NSizmztBNRDMzMw01U=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.37.0"
      "sha256-7WCHPCcPl1d9j0dWT8KdokZkEKOvtb+ablzcRnrjwng=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.37.0"
      "sha256-Iezj5iaC7WqGNlVLcAyOiiNT6zyUyjew9ZpUjS3Kp4w=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.37.0"
      "sha256-2F+EEbHmvk5zOUzDGYBUTotFXm3xwfz9lQzNPQ/4fko=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.37.0"
      "sha256-Ma3UNZxFnVHhXZRryWJS1HE2NAJAGTy5aDSXizECTWg=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.37.0"
      "sha256-++3ixApRniFY/gYZDA2ae6dtAVyxE2ujciTyLT2/vbk=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.37.0"
      "sha256-MK11RuIgZfoy8vvZWHFEJjkSsJSzqKjXvm9GCjt3QH4=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.37.5"
      "sha256-FAMF7HEM+StH7vkhPomIxh2GRSIhNxQaCZx0o6/EoYc=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.37.0"
      "sha256-/Bp4AOIWuCQ+CxvIQgk7ITOkYuBuFX6vxi2S2ItZeaY=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.37.0"
      "sha256-Z9taImHQlNw2YviORfWIVQTlhAIW/eS/AA7JGqlNqDE=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.37.0"
      "sha256-03PbYwj3MnAzmiM1ln9ay6Bn05qPyPhF2UxXZpBSqsU=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.37.0"
      "sha256-SiZDE1935EX8dBX1kA5Ea7iCuOQvUbW6VIk0VCj+vKU=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.37.0"
      "sha256-ZksL1EtJj4H12D8JvRS8sTDnhKc2j+1UiRlMTN3yHGc=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.37.0"
      "sha256-1qVuMxUgtcGrwzpgrR6BYXzNjtI605H30qensAnbOdg=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.37.0"
      "sha256-VxCPEFTQec2C3JXKU9eXueyIOdbpnOoXDBEGbOuvgho=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.37.0"
      "sha256-5rf6lym+LUdtellsFlCOPcL7ZR44cxL7ozMG77QBp4U=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.37.0"
      "sha256-xDjzytVFmlZuYKcvzgMsVfyT8Xn9X0a4/OHZzLW80pI=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.37.0"
      "sha256-AJak8nEPgCUoN17Gl4VZJ+V/XAeoa0MA2CLz9e3l5Gw=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.37.0"
      "sha256-MpAvfi5ry63gtT8Ln22BAwr0hyAgk0eYo29ekHCMLfc=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.37.0"
      "sha256-83T/e9FdPQN0kipc6i0xY8d09zchD0hQD7RcY2Jcdss=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.37.0"
      "sha256-UR9osEtU2Xjpsk1Q6lizh4lYRXqt8FQhF6Ei599wWf4=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.37.0"
      "sha256-msMwB9OLSH5bWjMAmNo/gRyjyMP3MVbi4ihsTc0vJhE=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.37.0"
      "sha256-WjBX9obty7j01aUFloCvJloDiETU55F6ECFI3qXI6G4=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.37.0"
      "sha256-BYB0ALiPT1lcGrt+r/BFcgtQRoxoG6sXj9T6b9IAPVE=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.37.7"
      "sha256-xRN7cKNbVOVrmFkYLyy9TPd9OTQIRX8Ix3vyGO3xXe8=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.37.0"
      "sha256-8++7Kc4UwNTGS53rlq5QZ/W5WRmxnLog4lRXz2DrB38=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.37.0"
      "sha256-qTRgz+uAHDYJWtjED5bAVURgXCYk0ZAnto97WKBGorQ=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.37.1"
      "sha256-YtWLY5SEB0t/gk1qDf+UPjmB58CZdOs9GZ6JLkqRJE8=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.37.0"
      "sha256-TqYdke3fLJRHZBmHbFkQYxPJ+Vm6aQyI0XNEsR12FvM=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.37.0"
      "sha256-sp2viLLUNRurZbDPlscmuqwo4Mgi5PA0cl68wtff4A8=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.37.0"
      "sha256-AK4bOVdDkLDhhJPKmXLEbgEDw4X7mUA6ZRPFctNumE8=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.37.0"
      "sha256-XUl7lWJvL6safxXCh1bLWz6SJbSqoY0gzLkrhm2rgJc=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.37.4"
      "sha256-GQxq0/FfkLrojbsPpkrmgHmg0B4v0Jj5sluZoeyQqGg=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.37.0"
      "sha256-dq8LrgsWS7q5GHypTdDUyD2V/qXNkhI6IhMKoo1wqps=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.37.0"
      "sha256-VezOut+20Njj3hHaKyMmks8f+/Jmv10aUOcjDmlHfKc=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.37.0"
      "sha256-xeRuUCpBlkdbVKBqEsAJf93Bs1t5XpuhFynerqSwT/c=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.37.0"
      "sha256-Ip3JFGZnN112dRHwGbtx/Qu9lIhBkbeB5dTIJ3TJFEo=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.37.0"
      "sha256-ukIWicPwDGYWqwXgwhRfuPl9AUu6OGyqibGkRRpJ0rg=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.37.0"
      "sha256-pw1aeeDPy05KNtDQIukOtDScxvkI6AQgZSqCQpdzFKY=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.37.0"
      "sha256-wvOqjmqNMbCG7E1o+ZSOlWEwBdcCKjD/qVFlepZ51ec=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.37.5"
      "sha256-0isaGfUCSEUl8CpbmwXHO5PWIHbl+/k9xVR+2mpJiUs=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.37.0"
      "sha256-Sqer8nDDdeGo8/ZEi7Cv7duJ2OQB0uEBOAY9CsaKDqI=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.37.0"
      "sha256-SpHLFBc0vXSkrPVJ0dfpLLap4ladWARi1aQkAzBrkHU=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.37.0"
      "sha256-7Sz4g1+0B99ZybhrzJOS0K71thybaDPUYmF4+SN1sGc=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.37.0"
      "sha256-bL23Spt21iUGPYuDKphfHHaMMeGxbsrieowsWA+0wBQ=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.37.0"
      "sha256-uKccWDS0zhFrs6CQ9ve6by4rYL43T6iFZ3rjNy7SiyI=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.37.4"
      "sha256-KuV/D7dQ87HL+smlqSrpGgi3/uw0zbP/SZ2PHgH1h/s=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.37.6"
      "sha256-qLRD+/08rWFA4cocIKyjXR8FQaX/Ho2nPHySbQEvu6Q=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.37.0"
      "sha256-LFL4/kd3QdyNo2JMQiJYyrsW1nUfMJ9/LWVDE8qx+wA=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.37.0"
      "sha256-h1hUoDGwVC3shOU236Z7GvphwsFnm+6lVMVYz7hjadM=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.37.0"
      "sha256-2loxTqxOQxGiJkuLh7qgIaGSuML0/xN3f3AKHQoMT+Q=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.37.0"
      "sha256-annWTOLZVSaLkPLfzHw80J4+Ka7aJELGC4OadeRdCEY=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.37.3"
      "sha256-sU9kfLIwN/wR6/xu3YI70jXgAg85Mf7/rL5G7xxmsKs=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.37.0"
      "sha256-qBDRNmLpGei/Vwdl6FViIL6qLphVQfJwBpDvauDP1Ns=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.37.0"
      "sha256-lDjdGwuVL4nHr15/bsRltt0AGqvMznirSTX8aiQY/fE=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.37.0"
      "sha256-JWoUicPKfYEWcJV9Jc/DqxTwWMskVLbzxPwuL6W69zw=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.37.0"
      "sha256-jKo/VYOtHEWPFh3w0Q3rg3nlreizEcNG7C/eADRNy88=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.37.0"
      "sha256-4ncbasnlALjaFg4lDKHwtXGg88Z2+DTVv/cPXlfLlBg=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.37.0"
      "sha256-MQJMX5Zv1/Cdd70NJZCXsMe3y9YLWvELE/u+gDfgLfc=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.37.0"
      "sha256-rrHDyRHjXMwNF1s52zi81o9fQnvzfJnNFQYYHK1lwy8=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.37.0"
      "sha256-MNUVaGlc2+UUEePFnslKpti//rJddHW4NZ8yZdOuQBU=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.37.0"
      "sha256-+OaeV4txp25XN9UB9GSLc9me9Isha918q2Hn3gyAPHM=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.37.0"
      "sha256-fe2N065m93H+/0dUe2Q5yFjGVFDG/Gxq1jU1mYKtcOU=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.37.0"
      "sha256-0Z6WKKbucAFPy5MQkxblr4TUC7lLAp+0yJc4t4gE2X0=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.37.0"
      "sha256-6sweonHO2L2Ff98CGtuFdD2q3RGWy9rlk0NV8l0hvcg=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.37.0"
      "sha256-fBOuX8kCfMYEiATBBuMBdkT8YdvmDB6JshkvO06j4Hw=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.37.0"
      "sha256-06+v/pedzD+5J+6vPmGLf07cHkTm7h2y0oDs0bU3WsE=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.37.0"
      "sha256-wPym6XJ09JuqPS5ee+5iU4jXrtCiSutNE7BiZvP9w2A=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.37.0"
      "sha256-p32uq+oF5IVsI2eoBjmjmZO5actsyghuB5R81fuCEYA=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.37.0"
      "sha256-H/k893rbdr/Z8h8eP2bO5hWnwYNsgSWpXSPaBa/DPHs=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.37.0"
      "sha256-JSVZVCZ6P5A+EqjXHmbbDIdE1rKrdSwNcZvUbYxKpSA=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.37.0"
      "sha256-Xi0qA0cq98YeOAoJCGuXUk5cIEAkkhOR3KDaQD7qbic=";

  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.37.0"
      "sha256-KE/Dg7NPJ+bXLCMypEpgcVrsBnp8HebDVmu39f/30QQ=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.37.0"
      "sha256-J6QYTDL4NBIWagP60OUXk1O+RcS6jYk53XSimlBBVeM=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.37.0"
      "sha256-RVay0BEbaqtWdNpJo3eswTIq+rRnLuDPRcvOPsrl8xQ=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.37.0"
      "sha256-Cr6VKzjij95Bs5lza+wxNNVWBFR10SL9wRku5tlFeGQ=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.37.0"
      "sha256-wF0XGOfuNYHC0nYnK5Ex+MHwPizLSuBUjcsUJTyWq8w=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.37.0"
      "sha256-yjDwz0QBJliUJSmyEt4DAgDujGITCdBVOnjV+C3zhT8=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.37.0"
      "sha256-cLuH24dACvIWq9+UDtLaeIXe8V7o8lz5oltGD94tTrU=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.37.0"
      "sha256-FlGDGUvHmvhPlrjXh7141YIOJh2P4q8baWINYQTfxOU=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.37.0"
      "sha256-gwoKfNwNCaKDnPcTDIj5+H3M0xPwgafyQiYxZEEHABI=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.37.0"
      "sha256-9YhNPBhrgqEcZfJ91StQOu44p6XEyUTpOjq45mLBOi0=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.37.0"
      "sha256-CzJQ+aqu8YRRuywzXXkf9yUuqbfvabjbV76vmBwvndc=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.37.0"
      "sha256-RgmXpEJXEw/FOdxuiSs09BAhsgb4WBJj6/icuM7uCrI=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.37.0"
      "sha256-iFTzEIhVgRojrEBJSsl5kRS1diHZr3pfuSgqj5La0Hw=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.37.0"
      "sha256-VoOeyU+V9ciGtDBFwJeagMuPCXDjoSf8kUneJzhDarE=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.37.1"
      "sha256-yS8p0zWNgzASA6X3JEwJJSytmwbYbomgNe1xiWYHDok=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.37.0"
      "sha256-EZea0vo3qwFbk1EvVpCJBPAiz/8P0yWeREKr7mfZnlg=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.37.0"
      "sha256-Xak4A3V1bMl4qik6MHlmFW/ex1koGw4LR9aYb205vEg=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.37.0"
      "sha256-MkN78IyKgcYtxaaPYrtHXz8Ul4flgWiFD2Nyuc2hHHw=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.37.0"
      "sha256-EVk8HhXnmIH56aLsXl8RPZ8C2c6ydoHuLMmLJ49WgOA=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.37.0"
      "sha256-Tyu9+nPR1sjk6ta3f758RJEn6KdJjByZQhlqc36VMSI=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.37.0"
      "sha256-MSjysM2CdZr4R5lyboQJsGv8K1N5wZN8PbxPxWs0AXQ=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.37.0"
      "sha256-eEq8LDmORpA464IecxTI6FqVIitn3t+t4ElsHkfSAs4=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.37.7"
      "sha256-kZo2Ovxe0zRKVbeVdXR5hOJs9vznrk2h4fuBX0LiKd0=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.37.0"
      "sha256-cbEk1zLlN9p39j2ieLX0cnbazR/pp/tcBB2lDM80c04=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.37.6"
      "sha256-orP5EctM9M8hGTIMNcFjKlWLm4CNKR9KjQo3yUqPTlY=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.37.0"
      "sha256-4AyJ/+SE5u2hIWgi6K1sfiLmSyd899H1swQR6gTo9fY=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.37.0"
      "sha256-/YnQXdkazAjklYHhxykdLgQ1ciLXODg37e2NwLnqtJI=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.37.0"
      "sha256-ZSBmESqXR8TXFP4BnE9Xj5UBErBgooNCbLk9G3lpJwI=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.37.0"
      "sha256-62NDO0fNYeXWPqgst4EtVywX55vN5x7+1Qv2Q0IxxKg=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.37.0"
      "sha256-puoVTYPdhSKc1oKZ+sDYvz85UN//IO40OY98lvTWkdA=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.37.0"
      "sha256-qX3KU2/BAPKyPX8mZ6kMbfUtZT35rbUx/YgVjicq85k=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.37.0"
      "sha256-SiyXSrw7tNj9C9LAYdjp8kXu/nEJ2asX3bEPgZUcKTg=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.37.0"
      "sha256-hrYoNIGeKC6JMmMtQQnORTBx6MF1M6n/ZZnq1AIzhhg=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.37.0"
      "sha256-TENeNcqFKxiOIAaFPZNhyQga812AFTHPjmZnDlYlLKg=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.37.0"
      "sha256-WL8F1hFsE+GyJvWY8CFrDHN14KD98RcsSv3+1uwAVQM=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.37.0"
      "sha256-VuV6WmCMyUIbMm84kjAvxE8Pd9xUpSF9RkO3XHVg6PU=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.37.0"
      "sha256-W3ivXrEvOQrLH17MuXDsFxKUrUaOo3PQmpq0uyaj1ys=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.37.0"
      "sha256-t5Z7T540M+ifCdUT1cV04PKqERHzW0XIqKwvYMQ5od4=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.37.0"
      "sha256-CUsiSPwQJLvTI8nzdd55SbbUtNoLvwEWEM/zO0CCzWs=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.37.0"
      "sha256-hPyjF0zdzH8UwiAK7OqQffbl0r75L7KAkAaVWNFmOE4=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.37.0"
      "sha256-/iPSMr9pwqbAmj+5E1Igc2rgbwaKlvRG0w3x4mWBzzw=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.37.0"
      "sha256-b8REBC4pkmUyhl9uln1E7ugPIsxop6XdoOA1xOLymtc=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.37.0"
      "sha256-IJ9ebOx1DVer16v7ck4n873BESC4gIFZi4QEmoILiPc=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.37.0"
      "sha256-Yb8XHqU2aHqiVH+134wOd7qRgjzJiVz8h6MgidjFXOo=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.37.0"
      "sha256-5wgeRfBkLbX35PGmGBciTx8gVS8Uqsh5WG8NeQwmEJs=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.37.0"
      "sha256-6HsfUV066CiTERS87hsLDqaCnj917ZTyBxdcLH9nvfQ=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.37.0"
      "sha256-YbGr1bfbpdFvneTZcX8vZ0OCRtEc3hwrvjHqOHUzM8g=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.37.0"
      "sha256-LmRJQh2p+bKkJH6wBcMcKvPTc+CV+CphIGeiNyZaMNM=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.37.0"
      "sha256-LCz2bmZAf1T0ueQOb4H8tfqc7tubGtBRYbmk4GfseKA=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.37.0"
      "sha256-BpkzyXX7bCa0fLb0mMI00K1HfCZxof/bI3m/gisusY8=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.37.0"
      "sha256-b3JBnwLTABHj8XaNjhKHjuFscmcO29JnFFtK5v6Ak1I=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.37.0"
      "sha256-duHIjwoXugFgIxsT51/G1+a1O9gMYKPOn+8CXkfDlVc=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.37.0"
      "sha256-KolHBiYkyFntiOh7fbFytnhfKhnz+/jkXI1PpD9lIzo=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.37.0"
      "sha256-Q3LbIvZgdUj+M4miKLCmvJ/8xwKniGDzslapBVKrmR0=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.37.0"
      "sha256-h2JU5d5xFlRFmubn04Fj1IpmChHuopFM9m5NOGjB7xE=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.37.0"
      "sha256-PcBNOGGOtp+7V8UTqWIICoT0GjzYIx+XXx65neIfP9Q=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.37.0"
      "sha256-njeFSZ1IznNCfy951bkIJz6plgveQLMyhNTJX7BBw6c=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.37.0"
      "sha256-hXtY7MFv7O8Xu7FYUCeOQNnkSQNpaaMna4I97T7L4Yg=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.37.0"
      "sha256-DKOnbmgF1khWJ2IJBB/B8Y+3aleNAJqiKdd0H+3thf4=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.37.0"
      "sha256-9lGnqh0rDZ7/rwRXCjsbuukQPQmXjAVWo3JLx54S+j0=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.37.0"
      "sha256-c0wUJOVedNNLLYW7w0ZG9Dcpl+w+OkQylTSLxipBN/8=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.37.0"
      "sha256-YTn8EOB9T+drHaHp6ET7Nh6HqPRnd2B5NMdy+HiZZxI=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.37.0"
      "sha256-/nHhmdGNSHJ5/v1IL2wp62uWuwnusDbnkihjmvrv41s=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.37.0"
      "sha256-Dnm6sKxzxlWiiycoYhbkINspz4OqLRMxAn4BMScLwEA=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.37.0"
      "sha256-naqXWMUnk4wjL9Tb0D620BYqcOaKxIkkiGXObQZ7THY=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.37.0"
      "sha256-c8b/bdAfTYFJPJaK3q8+N5jQvV6/aMsoDbOxGY1OZL0=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.37.0"
      "sha256-f7Ds+IyF+94s563loNxTAiOv1bPqTLEjckk/mPXJ+r8=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.37.0"
      "sha256-nh2m7H6RlfQlqmiifwYJ3SANi73zcju/v5s9z26HIvo=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.37.0"
      "sha256-KFa0yNwhYlFGz4ADpsxt3OCZfYDBv6Hfw9Ti09f7fIc=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.37.4"
      "sha256-xBMBhCrnTV7sILg2/dXUy2PeNeCuNHkb7plAumD5Pq8=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.37.0"
      "sha256-iiMMahrizVr130wfPOzT/N+WWWfWu4yp+/Y/m/lWoKo=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.37.0"
      "sha256-tT+F001HVeqcZFaj7BEZw+NIZwekMRrNPo5oNR2OUhI=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.37.0"
      "sha256-c5KHSqJapAh71+VG8ZVltRXozAF4muW/p6d0g5EH7IQ=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.37.0"
      "sha256-glhDsaa8T698uYZ3EulIPfX4YJwNxWS0rdfr8PpDA8U=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.37.0"
      "sha256-gQwWhziTvb8qr6S2r8nvqszCqWKXCjrh50zblH8stQM=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.37.0"
      "sha256-g/KoroOmWZgWPfC0HMgLGQrGpr9QWEirTL3S9t7iMjs=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.37.0"
      "sha256-IJJUCcWCds3xb01lV0ghy0Itweeg3vKEUW8Pmp/Er/I=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.37.0"
      "sha256-bySahvnK2ZFX2wETtu+PQyhbMYyH2RdcYMNEDnYMTzM=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.37.0"
      "sha256-88OSler+2SJ2zDYtLmM5NeOPafKIf5zaLV8MMLRb5es=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.37.0"
      "sha256-0lsfrJZ0a7+otX7jd2uSwBbbL5ogyFbnsibRI1bowPs=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.37.0"
      "sha256-a1U/zk4gLgbmNrlugN5ZRWHS8SfcKm7i8IxU5oLjq1A=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.37.0"
      "sha256-N0/6aVM9GgArp7A/XUQzDGE+ZDS6jvtsrqw3/kCU1Lo=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.37.0"
      "sha256-t176yLETg+7+0CLQ/4krTAbpbgsXX9VqL90d0Xx/2TU=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.37.0"
      "sha256-XRMvPnaqyHlPsZGsy/zkuccGnZGftvXHPyxCOa9ivJo=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.37.0"
      "sha256-zDIuMI/90Zwm0ViiRxnhyJc1Nz5dg4iUDbtq36ekmk4=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.37.0"
      "sha256-IqLHHwvWIsCvREzbPW/9k4APEuQFVfJD9Im7Q7mjYtY=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.37.0"
      "sha256-Veuj+t/PRiyErLFNqfl1R3UeQpvyaaNs1pfI0G9IaqI=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.37.0"
      "sha256-W0V+KIyfL551/RukX1HyzC8NiN9CtV/D9Fon3C7zdJU=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.37.0"
      "sha256-UVUivqrkG0oLLjMHw587VFVSolmpzaWdon8Xy2JKjis=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.37.0"
      "sha256-VrIQNJMCdsdvi1zRJpxS/FyVQ7Wafhjx+k+eOLiP5ew=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.37.0"
      "sha256-gA8+WKvFzCegzUUWvsTbEmHkYPLIomBrqaIRJHkJqhE=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.37.0"
      "sha256-O9iEc3Yla0/bmvhouX1PLQQET79uJlbQtuz7aKrOekY=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.37.0"
      "sha256-XQd/4cp7d5DB9g0QU8i5qvUpycPx4P3CxwTx5pijSLQ=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.37.2"
      "sha256-XJE33wPIGIlSVxrJ3qE09AmFLkYwKR6zWXXtDnEVvSA=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.37.0"
      "sha256-L+XFhueTb9fq32oyVVbysBMXgds1UlXryqRwiDOI+Io=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.37.0"
      "sha256-i+EBCV4AIOaSam0MYrtnqD+BPvr5CraDzOownJ18VmI=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.37.0"
      "sha256-4uds4OY0uVk00x2eAjlKev/l80H4GjUMb6wagHDJwWI=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.37.0"
      "sha256-EA2UauZXjSQHrPSSqBnFwJXnsbtPIh16J8EMZ69BCRQ=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.37.0"
      "sha256-Z4FuwV4FciUtX9e0zTemuFMLh3UneBt6Rrw+0heF5fI=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.37.0"
      "sha256-4DWBTIGHw6kRAz5BSNO9IkQDe8h/6ymxJ8WaReoIOfY=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.37.0"
      "sha256-Pw/BAkTFGSJXFjERmhSCC+kA8+9oDkWUHXRbu1ntwyY=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.37.0"
      "sha256-mmn/gZQQBY0AYpC/wiO5NuvbRs9AFPbtT8LvjG0QUJk=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.37.0"
      "sha256-5t43MNckv0+Gxdmp+4dkxMTtl9ToTk0Wfq9W0jr4Qko=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.37.0"
      "sha256-2JlRaJI+easfcwj7TqYJ1B/9mGlApbQ0sh9DYK2gE28=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.37.0"
      "sha256-+kdNkCBxY7tyNDgmZ9KNhkv4KB1kYr4A667AeRoY0XA=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.37.0"
      "sha256-/NC3h3x5uXVuxvo/h0l8ByN/WUH6pgQ1twhlaFevQko=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.37.0"
      "sha256-qUtv4DOn0Hle7QGBr3cgphQXDNj9iC0xwOhCGHaayW8=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.37.0"
      "sha256-mClCFP70uTbiJFQcHQiJwwnlir7lNoonswr4/i2bgCM=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.37.0"
      "sha256-0Ha8v7Fo8R3mh3nBNmMaWcBT/FceLQiwxnL/1ZpepaQ=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.37.0"
      "sha256-34925z766jg4v+zt7pmh/SgUkYfz9g4eDx5jl7bviUc=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.37.0"
      "sha256-epGlYuJ1054KG89uzna+fxvhRYxF6ajDv2e3QoPBrGk=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.37.0"
      "sha256-w/oYhtW5+iYRpyFEPshdKn80dyLIicq5/HhvNP/Ne0g=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.37.0"
      "sha256-iZphmmci0zgWBSe7Q/7t+s1WpB8i5XABzVkwrxLuSvA=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.37.0"
      "sha256-M0gmUpfwqZcZimW+hyAcWZ1MvQXlMhhLhO2RfttwRGM=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.37.0"
      "sha256-/Wr+oP8wfgSoeynyZDJ0fTS0T2oeBXR8DctO25S7qPU=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.37.0"
      "sha256-xPW1Ogeucuynd6rOGji/ihdWWrEzTXQdqcjiJeFX2bs=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.37.4"
      "sha256-LGVcSjeM8AS69PVrUAqh+KaB94Fi1/KGbf2+kBPUu2s=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.37.0"
      "sha256-0rSXHg5NM16PebMnq4Cr5ToQcauOEbSzJzJQU1Oe0xM=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.37.0"
      "sha256-u+jh7zfrDUUXtFT2PjOlQSJh1Bv+xsaJekldwHn92Sw=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.37.0"
      "sha256-CE6/prrf6ZCoWTG5aPejO1Bz+FIFBeqYDS21UwMfmPM=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.37.0"
      "sha256-WqMrD+uGG7YQIQagu8L5pUOYMNHeneEQCYzkWrIZ+nA=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.37.0"
      "sha256-+brjIm6GDK95Ft7bcCRKiEB34ERKqoLKwF18XlNp+fA=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.37.0"
      "sha256-zHUGxicTW5aIZIh562Tvr6qQ1K0BSv+f38iCLh39d+I=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.37.0"
      "sha256-csr3DYjsomhq4T+97ZEQdjt0RfsXbo8kBFGrB6cUUmM=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.37.6"
      "sha256-IoXZZE9YwtHROZYy3A/nmSfhkpCpt6GE+AyF2KTmXlg=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.37.0"
      "sha256-618WyrzlroxtyDGJi0ehIBQAYnGbd0JAfMLoVKlCFGc=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.37.0"
      "sha256-wG3bvzu38UyCF8n0J8gXnzzPMeJND22iRkjAbTADVNI=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.37.0"
      "sha256-gYDvPgcW0seMssURndWp29BxBzNnPPvPLDRXHW6PncA=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.37.3"
      "sha256-EAlTSaiF3t6eOMP/hlDTtqI0l3uX6oLOMZ7Ij+Qs/20=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.37.0"
      "sha256-ozwlq5US07sA2HMoOvtyo1/d1O8ixsMFqthTwo3BWjw=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.37.0"
      "sha256-wLY1vGfvF5yWbCY88AVzLZ2bJlpuGAn4F+H+G0DezBQ=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.37.0"
      "sha256-031skcPZd/jBWIod9JAbIc9NUcEBBN33UxIoGc2IiAA=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.37.0"
      "sha256-38L7Iirnj8n6MnWSCY1ZylCAECSW4wo3gvddKq74aIs=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.37.0"
      "sha256-JZErRwxR1RB5l3JhHByOWjtXdzaJEkYQZE9wgGkC9ZQ=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.37.0"
      "sha256-u4MVTUt8qW9Vmr8+qDMke5gukzriEAxPb1pbG+HaJAI=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.37.0"
      "sha256-axaTu4XmHGc3a/Uzs1/0IqLJdZFBfEQ9pzi42XW11y0=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.37.0"
      "sha256-mI9acOp7w3pD+5eD3z7pSgTxZHjYWWbkRnWYUWy7UpE=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.37.0"
      "sha256-0hUuTUVv6+WqpPn+TJVgsl5bIuw0WejLarVu/hv1trk=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.37.0"
      "sha256-VW984jFkCzfG2w2XP5fa5eiUjs31yTQbX5jyKuFIS20=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.37.0"
      "sha256-BLrTyePwfPIYM3eRRBncGPGWOjnIRw9TpvYXwAD42Vk=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.37.0"
      "sha256-m7jX2Z+PVIS70S+LD7eCYWqLiSSyReKv4z+/fpZ3HPo=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.37.0"
      "sha256-/4XdwWIkx8VYxrUp7I8IDCPZ34cFudV+gp3xR4uS8jk=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.37.5"
      "sha256-/cLHocPVefBea8g6oIRrSis6JOL7wFw+AEYyGNEOdx0=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.37.0"
      "sha256-vG7Ey72OAgYUPZsfJJJ+CGokZ6LGpkH+uXhZnXWVToI=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.37.0"
      "sha256-HlCKfH/+QklUjmfzX0OuqKYNJC6wQc7fNXSMca5cIAI=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.37.0"
      "sha256-c0vXkW5sR7JkdzvsS/rMFme9EwY1x5eZAbRWYKew0v4=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.37.5"
      "sha256-CZmB3zmQwsWy85vzK891HXuRfmgNBg2YXEasihOrbUY=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.37.0"
      "sha256-+QJSB+rrGosPxi/O9rRp/fZ0sLh+/a3dDTA8ef1xyck=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.37.0"
      "sha256-ZbzXY/4h5g8+l8knUnayduHLsJhlBf69hufbiCHNZp0=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.37.0"
      "sha256-mVYTPGFLZM0zMhbsJv7pej8z1aRhGOoaKZB78g+XXS0=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.37.0"
      "sha256-lucySLBSMrg5ENzWKW9EkEzZgZYEMq7BNKmaVDlZAVI=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.37.0"
      "sha256-LrjiQaAlhkTpW/Tsk76u4gFH66WBDb6tmMh+8oI49k0=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.37.0"
      "sha256-FQPurpofExwMTW4wmEX5DAg8jq24D4CtRESHaBXv1Hc=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.37.0"
      "sha256-7cWfa4r+1vVvZ5Z1OorZNlLIllaF44RSuuyW/A3CxxA=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.37.0"
      "sha256-XU/tZnffFHZRe0aVlN43v3vApOZHmw0+w0mHuUWP0MA=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.37.0"
      "sha256-GncOqi7qFYlBAoM0rz0J7kp+tcc+8a7A8wl9D9EOHMg=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.37.0"
      "sha256-Bkqp6Z+FWf0DI79bGraZai5iMC5eygvumStvLh+unQw=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.37.0"
      "sha256-BpQNhC56YA/fVCGQ4rD9Ncp5FMsRi1pXgDa6bOZZpBs=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.37.0"
      "sha256-lB9ls6aFWkUyhkVDKnQ3Jcr7rdfrsFEj+uD//R7pptM=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.37.0"
      "sha256-gcUVxwZaXBgpRFZNhUTDTmdJyQFf+dXEHDMSywBFaI4=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.37.0"
      "sha256-p8UzqjJKotp078KSppX0SidBrCOfGY1/AocYHO5xVmc=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.37.0"
      "sha256-toCWU6Bh5IJ5lupehKJ6EvsMKZz5s/uPWG9qF+4P5uM=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.37.0"
      "sha256-/MJaP0iTix/cyCxJrTuTWHf0lSCt8dfJI67Y6+PdJF4=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.37.0"
      "sha256-b9SB3hFPtlFGh6MdyqPBmY7L1JrjGfmIjMADRaRulDo=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.37.0"
      "sha256-ISQRpYx0Sc6dhlg6T9ofGfX6H0P2L3QdIzWYVkvwA7I=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.37.0"
      "sha256-hD2HVQKPSoNJ/t8VVOkaz+kVV3bF9DXLvYh6vG15GvM=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.37.0"
      "sha256-eTYbFMc/Dy8wNeD6HnvBU+sLJIjacf0Y0e78QCXmHB4=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.37.0"
      "sha256-mhzk3KDgjFkldsaFQEHTNW/eOCOnpXkHCcyeBkraZSU=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.37.0"
      "sha256-SXv8A4Q3vFUXZ/gv8fQ0+HbvVRdClyBVt4x/bDUv4ns=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.37.0"
      "sha256-XBBF9usRMGeQhfDttw11yGfDGituZsfR1AZsn9jiI+4=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.37.0"
      "sha256-gZw4C1ZQyItwrb/FSvi0ceLETMO+hkC5pAqt0s3c/fg=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.37.0"
      "sha256-BOr9Z7pTzVV25ihSAlHdvYR8y6AGDGe9WvbNetJER5M=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.37.0"
      "sha256-/gDAwLMWfdWhmDyWFHUaru94Wy1J/sgWYkgrujMM2z4=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.37.0"
      "sha256-FMyrkG+kWQZMN2zL2SA/QWQQ8UMUesdfCUQHupl61oA=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.37.0"
      "sha256-1VrtUyV443XdmOKZoxUnBAb+ezSs53JRvQdHd9aKR4g=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.37.0"
      "sha256-7VbfcklEJdTn0OBI8jIcwXUU+ju+38QQu7i3CcS/9WQ=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.37.4"
      "sha256-fnhpeIqk24UXEniZChFadkJbLebbKAdKHxZrlG7MpSI=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.37.0"
      "sha256-4YzyVZ8GOBBRnk0NATeMpX1LSUNH4h0PxUnSJqfGXOQ=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.37.0"
      "sha256-P+EAtNV7KBHpqZLOvuFFonPnSL+DDqUc28yeOItbfQk=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.37.0"
      "sha256-RAyyemwp05G1VPwlA/zc7Jv2OrWFiTTRy9d65lgUV9I=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.37.0"
      "sha256-a0607aluZZpy4QctAo+TtJWguDSi+1gQWPqday1TC20=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.37.0"
      "sha256-y4IyBLiayIZObpAK/to12GaqhDqiKnJDta+038BdNSg=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.37.0"
      "sha256-w7E28nqg4N8dz7MpAyRwMOJb+Q1bFb4JkmVQ6Cw629U=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.37.0"
      "sha256-TI4+rVDXiOqI1viEFwbSlvDbwzdKPbTne4pZsdK9HRo=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.37.3"
      "sha256-g7IxHH+/7ZUHGsRKdsCh2xsPjYUbg9CmL7Rqni/ANNM=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.37.0"
      "sha256-SnXlBwReZAM7px6zEif1iY+nRFsnnrWNRf2SDZW+yqA=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.37.0"
      "sha256-JBCoU6G8j0afes9TuOKzCjuAlfmFcF7k3930d7b9YGE=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.37.0"
      "sha256-tjKFOee35M0taBAcBPi/3xPM+4Uqgq7K0r127gFWTjw=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.37.0"
      "sha256-6aDSreVPoJW6fvjsblI/FhvKNvJEd6x6cstfiD+6TzY=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.37.0"
      "sha256-Q6jp3mno2bHBHEDvPBrJwgBpEm+ImlFJHIBvKyP+b38=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.37.0"
      "sha256-i1CDDf10g0E5aU1j0fTuBLtdSnlCZ+bijDIjv5sw6Jc=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.37.0"
      "sha256-aQHdWjauDHjUI37N8Nif29qWZzRhbSonUYL9ZxKTiVI=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.37.0"
      "sha256-XKJCht/z7eHSjhbPLXPbB5DnGmCdMfuDjEhZTIzE6gg=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.37.0"
      "sha256-mGqJUJF826MADOYCDXwPNbk+x82zumHRb+cTazCEzAY=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.37.5"
      "sha256-UonLSCWk8CUYjVBkxwbwxnR+NdQnsFTx11dZXIesDv0=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.37.0"
      "sha256-aLkoOhTj/VU+hcwm3Qb42k+2AhX8drJl9DdmE352Vn8=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.37.0"
      "sha256-zFNm+yUojgowwXWi604nKqOkguMDHyarvf3ee1dFHj8=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.37.0"
      "sha256-8HjZw2WLGdf61Fv8yRNSXrNnGUotS9fqgEn6+l7/k1s=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.37.0"
      "sha256-FYvcpTWB/yBcEJkcYLIIAOLIxrnPU4x7bnhgxktYgw4=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.37.0"
      "sha256-MD0cDJFNwAaqF65SUTeQBFaSfk/sUaL8owRKJGxtG10=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.37.0"
      "sha256-OWi6mpOe/tsX6e4mL5PldT7WNNdCk8VpmKJYhOUwgpk=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.37.0"
      "sha256-nBigZ8YNNcy6TrQQ+dThN62xZ5IOq92EHbC3/tZbbuE=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.37.0"
      "sha256-yonNSXiST3CS+I4xh1RpSAc7iqWYbpFluL5JzyrG+nQ=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.37.0"
      "sha256-eO6jC+Ypn01Im6GXo7KufnzDe1ZzASdU5fE1dPJ9KjQ=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.37.0"
      "sha256-zCSw+g6/g5GANZTLTrse93B3kNRGNfIfIANLZmHnz1U=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.37.0"
      "sha256-6JxX7gw1YZAQZcAbW/4r+kpWD89yePlu+AS8rgyUx7Y=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.37.0"
      "sha256-BY9wsXmWOV9PM4Ba+jyQCx6wr3vQEnHVGWLGnDjRzyE=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.37.0"
      "sha256-s/XZZvav3P9Fr6vyBII7NubWRChEg4HASNzN4UypcPo=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.37.7"
      "sha256-/ALXuHcQcD9f78ewEITB+6Ui28Yr/Bm07Gh7it6bjSY=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.37.0"
      "sha256-+s+4AUrgkXzEbgY2gYIBJGKBZxkOLFbFD6JdUfayPBA=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.37.0"
      "sha256-nJhGLgVx7bYXpX5iizDXyyGOSUCF0qf3JcsV6NNHrXw=";
}
