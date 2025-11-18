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
    buildPythonPackage {
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
{
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.40.60"
      "sha256-8BzWjJfv/6kEgJYsLmhIs9jgXx32yVW+L+DsTV/FfVA=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.40.58"
      "sha256-ZZe7b7krR5JrDWUS+YZcZGbFrRemvX7Ohz8xWPtVGDQ=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.40.59"
      "sha256-n8PwLnwMQXKZc5+euUBj6CBPO8H5iajC8Y0nQUO100I=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.40.70"
      "sha256-fAg3LGBfm8qIYBzxbBPOip1RlVCnxhmGmmVq8j/EAuw=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.40.72"
      "sha256-1YKWXOYxngzG6Ly2YFc+9Srp+VCmkMOSzaVmE6yfQwU=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.40.54"
      "sha256-8nNBUlGXVoracAltiBNWohK7yG8z6Q0KGupyOS9/Tpc=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.40.55"
      "sha256-m4XafAYt1vUe1nesd5lX2Lrt/6aeXWHTR3DUX0YkvdM=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.40.59"
      "sha256-ZqZTg/CLPUBTcZ5mbZJsA9f2sdIkgwQDn83xVWLrWpY=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.40.63"
      "sha256-X2wxkeKYvNCGbgFwA2jWSrAdPg5Pc7XCOvTauiZlLaQ=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.40.54"
      "sha256-/818ZgAE2Pqwcr914QvY86R5joOZ8kjM6StO4EpobdM=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.40.61"
      "sha256-C0MDOmvUXvJN3FuDsDm8fZQZUFFzACdw+0EpWCIpjEc=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.40.63"
      "sha256-5mjQ5qZjHW67dP9S34ojNIcwgNN8xbwuVwKo+7PtkeI=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.40.55"
      "sha256-Unxc01GzvKZGiKlW3o3ZrEZXthJPlMY1tu0vnUgYmq4=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.40.57"
      "sha256-X7RcwPwiYMSaj7QN8NHekxaLyzG7A+LcvJSElkeKZm0=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.40.63"
      "sha256-/JAEmxuUuHyGeoehZY6LZjUEk0k0WxuR/48kEc7SmsE=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.40.55"
      "sha256-JYfNdS/e3ftDshlXoVVTfw2+zQUuGy+rpdM0dIrD7dM=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.40.58"
      "sha256-94en37HywYX3u+7hR13d0wLmtjc1HyHclMMQotzL2dQ=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.40.55"
      "sha256-JWzHe+4UxLenKYXdNXhShTGWTGDFgWx6O8TAfxEaWPI=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.40.63"
      "sha256-FjGdsXuu/NPABrsl5JK3sPsOHGnAwTvIIv+G3MRxZxg=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.40.63"
      "sha256-jGO22gbzqaa9VcBKyyEo8QLVf/Uia6RrQGaHgIApQPQ=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.40.54"
      "sha256-t4mGNhPOii3GcMirgyvGZ53XmYf+GpWwMkL0RELswrs=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.40.75"
      "sha256-7/Uhmaab+gyBfQBg+mG2kwMlDcxJgRBGNgtfAslYtuY=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.40.63"
      "sha256-KRa98jsQ6MPZBWwZbPAmxmSgUvO9Y6XGkWngL1p5L7I=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.40.55"
      "sha256-as/i/8ByPLcr91nEwv+Qaq/Y8Rpi1qaVyMyDU7SMbc4=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.40.60"
      "sha256-hBkW8prNkpdP+7ZEY5YIs540fPDZX1sqbHzEHDWcZgw=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.40.63"
      "sha256-dzUf+/dAnrEsjxTcm2AZOqJeeWmQ8///8ORR8/o52S4=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.40.57"
      "sha256-haVFlPVqDuB6ZjhQ7ZOF57jfC8mNGXStDhzuMnObeiw=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.40.54"
      "sha256-pSEyo/Bpim0PgH0tj+MbJUIYwLk23M0mAh3LbTMv8m8=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.40.75"
      "sha256-cbIfWbUQNvGZDyS1K5NnxJoKeFpDSf0NWCjEjTL5H5U=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.40.60"
      "sha256-VhY/EqSIDSN6u2D87oA8HtTEZqkUzcJPlE+hHIg68Sw=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.40.71"
      "sha256-VS6UEnTCK3zZ5dcm731jKSK73hCL8SoNnOTE1z/w0tc=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.40.54"
      "sha256-gikBABSlCcQfBSh8jyIYdN7iyTncBRZoVPQ1UnVbwRU=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.40.70"
      "sha256-WlYQkLAOLDwWOSCGiL0oWWSqQnMT08Rul60gb/5a6qk=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.40.59"
      "sha256-Kw46Ncpneh+vyM+bFux/04DBDpXQrm0/HDkGjHcAeGU=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.40.60"
      "sha256-vV/nuOJeFelanrZSHeP7m92h1yf4Eg9hlURXzGqZNGA=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.40.63"
      "sha256-KpeAk7Kt3wZwgvGv8fOilXyx0FimkX6XFBEqEDvb5Zo=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.40.60"
      "sha256-HuG739RucVSvMev7k2WnqoxDHWnK9cT4bMVijcYRRIA=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.40.60"
      "sha256-6n8aB49OhrvimPJLxgXuNyn7vCcbm3KgyNg60EUESVI=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.40.55"
      "sha256-KMEuqXWo3YwQ3z0zQFZ7ySk3shgXaPE0q2nx9lSP12c=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.40.59"
      "sha256-gsvetyYmOYS5KzGzMN0elAXNDLrwYABwLwLMqS7AHoA=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.40.58"
      "sha256-yJHnaO8KvjYYWiJF8c4lrnf6Px2FyjSsMZsSjVFdkE0=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.40.63"
      "sha256-qmN6w6OGOBjOfEcb7bb24niw4cgot1UPyzFPmZeHgXM=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.40.61"
      "sha256-iS3jyYE2WKaSTegaRLK9jnWd2UxzqPR9F1dpuB2D1mo=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.40.63"
      "sha256-oFy3Q1W7tGdeXbMphjF7pYJjs1WVbKRQok/GQbjwbGs=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.40.63"
      "sha256-icJPjlbaZhbXRImXTU+guTKyEln0Dg/VCbQLOVKhZvw=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.40.73"
      "sha256-D+hZlQDljr98l0hFDqILxNhwZhIlyXoBIJCWtUdek4o=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.40.55"
      "sha256-3md69cxJv7R4cXqznJtz4+r6MvFw22EckaYzCfBJS28=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.40.57"
      "sha256-XlV7rtzGlcL4iTrJmADZQdlvtAJFBDEUlP1kkeI9kQU=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.40.57"
      "sha256-T9ek0te0KDC5Z3kdsprbEm9LvmlfbSW7Nnoi5s4hGWg=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.40.63"
      "sha256-EdwdwO83n4Gx3zcDeQtW9vHj0mg/wVXL+/REyWvNjK8=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.40.61"
      "sha256-yFnrI6ZpnJG/zBbc+MrlNOXwYTGT3ANOUETi2aC38cM=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.40.59"
      "sha256-e8ET+aC49Vl4JOIPFlaglzM3e34HmrbvJPyOj4yLQeo=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.40.58"
      "sha256-ywvJwaPTrQIoZ6xrQtK1/7FFVMM59ls1HOCUFSA9Pv0=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.40.63"
      "sha256-rIshJJ2HohBPXYlWF+y3KY7GuS5adzYWrjll0Y7HqZU=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.40.60"
      "sha256-mVqTF57DFNmD5JVbc0WUeJMV+rHfQG8uVorQ/vd/RkU=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.40.58"
      "sha256-IluCF13Ch70pP6vikKKgr0eN/SeiFLb8Cnxio6S58AU=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.40.63"
      "sha256-ecfKyHRa435PMsQppEie2wFYN9CE1HcQUZSd3TLe7z8=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.40.63"
      "sha256-jKSLa9U393dahneBYIzFpHPa57EtcqJ3rJvB62EsKlU=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.40.63"
      "sha256-sD53LSKVeYIipxKLw8SBR2zcxksM01zfVQhHtW5fZkA=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.40.57"
      "sha256-0gWiYnCPGcCc4CWDKOrlQxYjnGzB+rC8bWPBth4W5ZQ=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.40.61"
      "sha256-NQ5S5zqviRDtAkdYT5yjNikvH1ki7Vqt2+AzAAcHr5A=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.40.60"
      "sha256-5KmJ2LCWn0Fc7AGfKe4bB60r5Yvlu+aEYLk37kh4xyc=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.40.59"
      "sha256-2DJafQV9fGFILCPSFZD/oEx3joh1tDOqJLl7KbU4djk=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.40.58"
      "sha256-cAx1/vNghHwT3nx9ExfLw9jS/T6TqVkVhmXZrqI+OHQ=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.40.55"
      "sha256-MWnreUSpk4QdquRu1X4/HL9imPSYgl4fJz1BxJvcyPk=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.40.57"
      "sha256-IvcJJ7cUxoykNC7fryAtZ3w1WMypqj0jgBUoo/rGA7Q=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.40.60"
      "sha256-TgZlbzlU4ZPk3/aQQrwhTbXvV167tgahtfy23D1v0y4=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.40.63"
      "sha256-PzwZSGvdN1+tNmWZPOlZErP5WWk2eE0pE7XCh2/5AJc=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.40.60"
      "sha256-gQmIff1GMX6A9QYm+CHC6wYIOt8XEGx72xmHmEg4ggA=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.40.57"
      "sha256-P/frAydh31frX9xNis2vyi2XbswpcA0BJXW8TJKncFg=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.40.63"
      "sha256-9dwQLNrI8jlK7ay0r8rfNRLIgJhptrtMi94iZW+YzA8=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.40.58"
      "sha256-Nan0PBHJ2VtjEhORN0OdUC9TCuCNtOpICQ8WRHn6/YI=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.40.72"
      "sha256-icO5hMTaUuTzJLma8oDwrE0+fKqhav+EHlbbj6TyxQQ=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.40.58"
      "sha256-yP3OeePZc8Fb257lzsB8rQsahaz5/zqiH+XAQUUf9Ls=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.40.60"
      "sha256-q5aHrusyuFPI1ItuoaFskLoRQmDkBLwjV/Sch+G2l+U=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.40.64"
      "sha256-qizL2lYo7Un0mJtAdyksYV4dSsk3T4p+9F+9AvQLHmk=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.40.57"
      "sha256-BiKly8tW0MFacKF8mG80xsITdxegCcG3sKal7axoGf0=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.40.69"
      "sha256-kjvZbq00bwjGVPkPcSypkkMC0vIKURAJDI3RUpCPL2I=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.40.58"
      "sha256-XL3m3E1aFsbSVOvKg6bydMYLWaGRYL0RxcZA04Z9T0A=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.40.54"
      "sha256-mbbRVnRyCe97wfrWg5glIWmxx9czOCmJC4OrUVYRnYI=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.40.54"
      "sha256-x9YaYbLf/qq9OGLs2jhjap7TbgK8+HmADcnu+szrxvE=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.40.54"
      "sha256-iyXEvp4dra76CPor7FK8xsZ4zVojFv1+IcmAKlXcB7k=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.40.59"
      "sha256-X2gx7/NU3S51nHh2nRHeXQzOmnK+kk8DCPhbkFDtVMM=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.40.55"
      "sha256-0PHiMXZVyihKJTXEXP8U1fPt7LLGx+4EsJhXbk6VzTY=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.40.60"
      "sha256-7D+DnOkoDtXXrLx9orqg9WXtlnpSyQFAqgBlV3hJu1Q=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.40.61"
      "sha256-jF4evznD25FHYGxNEyS7x4RAbElEWMyv8Fk2uEqRxwg=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.40.75"
      "sha256-qUL6eLtqbCtmVDQuOBhhOI0yytay3TfpDHaPFeUJnDU=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.40.63"
      "sha256-saiHuNzlpD9LKnRpQVRaqIz1KPdWbB0wUm1kchmSqGI=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.40.57"
      "sha256-tmPAUD/9Y/HxJHzYyiRd+U/0emjnaz8LGRy4y9VeIpk=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.40.58"
      "sha256-Agrg2tHTdQfvdDeTEE054rMzKKwEiFWdcLjMFrItn9U=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.40.54"
      "sha256-cCVm6rzKk9TX7/LamWAPgN/nGWzwlbx/e+v/rDeAPRY=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.40.75"
      "sha256-OtxcOqy3dPO8qXp7gIGk2wYzC8VbPkMM7vN6GZpvYwk=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.40.63"
      "sha256-N0RWxdWolQadRfOC2zoJrixVNjtcZdA6hlmwjbeKUrQ=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.40.58"
      "sha256-km3Ehr7fWD0uXhLAa/I/5shLYcCFk8zoZLSc6XlTJMs=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.40.58"
      "sha256-tT1e3Z4awdzkq63uP99dhKQruzr6u3gMSRI8xsxxPCY=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.40.55"
      "sha256-obbn0FjZQDwFucsnH3N1+zfe1aWFE5PWHUWiLAeupqA=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.40.56"
      "sha256-V23RL+ESV1QGbn+kgPksEjIglwqdafdmOlbXAfKXisU=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.40.59"
      "sha256-EjeOxjAJluU8bI7i6TbDpO2Jp5e3xhVS9VKho5SkK6c=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.40.58"
      "sha256-eKwS+FXicnxiHr2aTDG+ih6kDxQ24NLCkI9XPt2LjvQ=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.40.75"
      "sha256-l8j8LKlEVTHQxII2ZkeA1wfN6i45jNX6Ocyt0EE35xQ=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.40.57"
      "sha256-NoZvHoanGVZhfvYyVTKcpF8RTd1ZZ2BuYCQ+QG6xPy0=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.40.73"
      "sha256-QxpIel6vTh99sgyJ1B70SKzaxtS7u0VWZSag2Dn0dZ4=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.40.58"
      "sha256-gyNKT8yjYFgDgEvBgUIvC0iVKIOLaCbLWcF9eYzQWUQ=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.40.63"
      "sha256-4cZrAPPo9rol9c+KFPYKaZZK1vQB2WYl34TiJfEbWco=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.40.61"
      "sha256-yS4h39MrC5jCVbAK5YhX7OSzyiG0RTEUPR8e4olV7TE=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.40.59"
      "sha256-Nk8AtGt8XKyBvEvQzjvmG0M3lsdqJuwrNvZqqU/t4xM=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.40.63"
      "sha256-o4EYOb30TxE+tLIKdEMVSEyyRSJ082ZwkavHHeUDr+0=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.40.60"
      "sha256-V5RG19bh6X/6Q72i5Zk0QO04uxbQdwo7PO6yNL1Stmk=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.40.61"
      "sha256-82MHEMIrohyKqBE7o822pDM3xjq3lJGwskyZyFxGNpA=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.40.59"
      "sha256-Qu/jsynDkXXBRBnJGNqKtmr4aSPwiFJvuFxEqZco428=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.40.73"
      "sha256-tOq1qNEVMNj1jCTDj5Io+si/PdPQnXfD8ukbe+m2dFA=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.40.64"
      "sha256-NxYFJHvE3QifWP6csT3Rp/R0Yd2hYXjSjfe6ds3UQz0=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.40.61"
      "sha256-uIOqO9W5VRFJtm1iZQsVdWIUomuHnbO6imSNBNBosMA=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.40.63"
      "sha256-6UY8UreMCPqP2EA/HJNwXLmVnbtSM1rA/iRm/r/+Ng4=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.40.60"
      "sha256-/ZqIN1Rrjblo4mhDYVqEoGkQb5TC+A2aKP26ORnB8lw=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.40.55"
      "sha256-6APIM38Kf9r2QefCAgXcAc9UPUT6+ymH1nu/WYRHcjU=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.40.55"
      "sha256-mu4434uXtTV2eq8rymiN7uqLDoncFwmdi0slIucwSjQ=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.40.55"
      "sha256-r71o2OkpgGBxh5gy23+OFHqCU0QI6Z/rQSBjDagMfB0=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.40.55"
      "sha256-7P/MvdQjYmNgda7EZ8GSI0mLPe3o19ETSspd8wL23Ag=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.40.55"
      "sha256-CQzN5qc5N34JKeF0gKoIzVb5wtdc8r2uar+Q6Y2Gd3g=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.40.63"
      "sha256-IdEuluW+mpjEDeuhptskEGDRoqQjylHCv9B2j8sYtrY=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.40.59"
      "sha256-FEBW/Vtx+MooC2lNBh9xFA8mWpbLK7qqBWWAnG80kvg=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.40.64"
      "sha256-TxHLddGOy2Pa0bld44WQCnkvhb1Gl6ohckI1TNG56uc=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.40.60"
      "sha256-2Ss/RklPHOle20l+feRjCS+fwgK5G1v2xhQsL20lDkM=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.40.57"
      "sha256-isp1Xxwze6EL2Be4I881yiGnQh9zcXVPXZ768Cz/Y68=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.40.63"
      "sha256-Qex9NGctqp5L2XkIxw6J9t4C5rqVzDmNCKWzQLI+040=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.40.64"
      "sha256-b3G9urLiNhC/8SnEqRBTlm/ns1vi7KtVqZzZ2U8G6kw=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.40.54"
      "sha256-p8iNFeQAwp5WdsqHNA8+mMBNvt6y1t6+erP2APopH0Y=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.40.61"
      "sha256-5GWnSiMWIxQbof20i0u12lVpONLUo54NII96puTXdoE=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.40.54"
      "sha256-NkEe4fOx9ZH6SHfa3A8UHXLyxIgjVGvy4UL+HkUiCDA=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.40.75"
      "sha256-lADLZSSizgDSKf2Ch1iOY43zKDw9GRYf5ymoErKcitw=";
  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.40.54"
      "sha256-GeYE+d3wv+KTcS0ve0ftTLXazGS5a5KMQmVMXMl9jtM=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.40.60"
      "sha256-+H/q11j6CwdS40V1BO8890nBwOYKo2JCz/plaemZHJY=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.40.63"
      "sha256-Q4Qxdpy59x3JkyJ3I54xRvGk789J6mhWtpLZcSWqr/A=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.40.61"
      "sha256-5o+ypZ8WRwWjRIcwVGT3MEkKziqI7/OXKWCULlumfFY=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.40.75"
      "sha256-x5sFdgdMa0oDHp6D2UJgUNHRLVsHh8LqWOeG+FTbW74=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.40.64"
      "sha256-sakRBiIRCBnOmEy171tY5496TT8GpWvw4IH0Su0plXk=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.40.58"
      "sha256-7ZJCrUmzKbFx9Aa4liqUCdNlZGS6fv0FHtifdm3vofw=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.40.70"
      "sha256-RytbLye6zUUQ+BmgvQpXMfQhJTh7ixGEPsdZ1j7iiHU=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.40.54"
      "sha256-A9nivPF85KQUnfo2aF6a50NTSxox2OlXXS4MuxNnZ1g=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.40.74"
      "sha256-fbXjZhG0qp86DWFhM+Kxlsbei3QmVSiZwD03Vr5XwyQ=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.40.0"
      "sha256-ba01dCNMlcTw/+WrulQkCtDagcPO7FF94cgkY14Pgsg=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.40.59"
      "sha256-hICeUgAlM80gO3gA7UO9mk8GaqfS1fMp4Wb+OU67+qg=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.40.57"
      "sha256-SPXw1zpz4Dug1fcjVUO1Wis20kTAZeEmpyopd2vDGAg=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.40.58"
      "sha256-mj2Pf4PNgBS0sBbTkKuszIcaBHf5kTwNzR3BYgoI5JM=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.40.57"
      "sha256-BZHAr9Qja9pNVrNd7dDmc/+bKfqmzAUJPoPJUMgJLk0=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.40.55"
      "sha256-bMEIZVMtrTmhfJTyVdpeBcGOPbIEwgEWGWYb9coHDPk=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.40.58"
      "sha256-Pj9T478mOGNl9aEIa6AtrDpEJe+8Ygkl2oQ/Lr4trEM=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.40.57"
      "sha256-uMwtG8llpdxfUCF6Lro1Y7MnozX18kXacZJe91i5rjI=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.40.55"
      "sha256-/W7eNwqtW8gJNJ/Z1W5jDo/wQXcbXOXfJYG+DaMR1QE=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.40.58"
      "sha256-j/LzJRyYqyThvR4MzPrSVJvlpHDhFkb4Hm5TjXdeWqY=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.40.63"
      "sha256-jhLj/7AWoC9oqprKhm+vCnwFSWU1aMBK8tmL3rX9sSA=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.17"
      "sha256-SeJi6Z/TJAiqL6+21CMP6iZF/Skv1hnmldPrJpOHUfo=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.40.57"
      "sha256-tjXQosCpHEcQpE/xqOxwTS+phiDyhFJy+54AqOg0L4s=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.40.57"
      "sha256-Hr1pVnskDI8b7R8mDCATnCS/nnag/Ac6A1tnQvXt/KU=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.40.57"
      "sha256-bPzbWMPCtXFvtOqIUXQkFUIThq9Qy5PPPlLBgz6+VgY=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.40.55"
      "sha256-xeWpQxCprqde9tjTR+oA3mgbfBPnUDQRwZrab0Edpww=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.40.55"
      "sha256-tJqYpF3z0HWRTHQmHjRyqnS3hCUxFUqsyScHnsiVnlA=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.40.73"
      "sha256-DTWmKTP7ntWL3eax3bY79eQ9ROLqv7jPVXetJbsGlhk=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.40.54"
      "sha256-t4l1s2RCkP572kbJLxsbh5EQnKZXk6zPc82PYytFzEQ=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.40.54"
      "sha256-gumv3tmf4bQa6HvlTAYh7yK0cE1jn3Gprt9l1iHgXqo=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.40.57"
      "sha256-DBh1NtsQTcmYUXEGwlHwjIwJt1NMh6+7h46uehwH4Jc=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.40.70"
      "sha256-ggYFo/V1uLHNd8eIsF+t2m94RQsK3myTD6rcP5T6h2Y=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.40.61"
      "sha256-n7qtEjUsWbqSzXgwOpAaDM5MJUCsOvMOABnxeT3MZ/M=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.40.61"
      "sha256-l7t+FqNlMQA9ZCjf0pypNX7WU3z9khuQ+Q9oOLviyCs=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.40.55"
      "sha256-GEFn9IMnqSQ+J0OP2Vu0zbKbx5/RmKpjO06GK494kI8=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.40.54"
      "sha256-NLkf8t9W/ZKA7S9qc/qJ1u4bzh87unvsQLUeh92sbvg=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.40.64"
      "sha256-5g/KLB69FD9/lojdZ5S3vWPuHBgdOjyrXxyDh0RZd8k=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.40.58"
      "sha256-mPmbOx2SZNvglOqTuo/d3F0CMh5Syka/WYpU4Imvbjg=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.40.55"
      "sha256-lMj1MhhWJeoSVaUPdELCDIOZCtL2rrgsNerHElczlEk=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.40.59"
      "sha256-PjpVKl3NF44wBSNycabduyNuR1inVbmaj4dUsLnV8hQ=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.40.58"
      "sha256-+nZT13/2ejl3kUvOyVdX0CWwxKqkGvhvXBAhhezhmXI=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.40.59"
      "sha256-9S4Y4WY3E03ckKXxq+tOnhyJPa6Msr2oxQo5DqzK78M=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.40.57"
      "sha256-82KGarHSOh1YMCqtWLoyi/89vYbRoTbcbhvpaSUg4pU=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.40.61"
      "sha256-lViXLfbEMpMenVxZmcp2cfhd0SqH2IiMPOIaOdimU00=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.40.69"
      "sha256-bLWUM5Ol9WZGqReXlyeduBlXFmnSZorLL4HmbBpBZBM=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.40.55"
      "sha256-IcUBufhnr3GfgJ0FG/JTwo0EgNZBtgKvTd6TtyttWRQ=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.40.64"
      "sha256-w4xoyD1wEmYcn1V5zjNg2J5Zxe45QffCKsz9qQ0UCR8=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.40.54"
      "sha256-1154wsf4q7QHWQG3PGo+ukUJY2mk+xfh3/56YKRtXIE=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.40.60"
      "sha256-kkkD8pNK/YYPELzfwvcQVAPb8GPusn7ggmkihp3+0PQ=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.40.75"
      "sha256-mfKivAqIrmoldDLsri4WZYIBVkBZPZ7m2P46dHdPrcg=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.40.54"
      "sha256-beE9BjjI8wZFwDy0Xzv0/BmRjunfJlJ0qASf4yfpxpE=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.40.55"
      "sha256-d9i0AUux2ChlTnW2UWJ/de9KRYc8HtvLSFENETuy72U=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.40.63"
      "sha256-5nHjl/kDJHf0QvaWqQVFSDkYxJpH78sQA+ilMCzu6DQ=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.40.55"
      "sha256-NP3FOwMuz5k0wk+ofCEzyVOKyZSO+TITyb67V82tHgM=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.40.53"
      "sha256-UzFFqox5VlOBemuJ7oPybKtNx+y9yNlC9wc3r1FidEw=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.40.59"
      "sha256-mQBymsl2+/hka8QiR+AzxS7gtONHroTgY3qmgt+YKOw=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.40.64"
      "sha256-XWGsDqlDWAmh4treGhQDb9t0QF8cAKWRdkJwY62qdOY=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.40.54"
      "sha256-TW5IgaSvPWbBu39VsO+6HMpgzu1TAKZ62RZGUQ3HoFo=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.40.15"
      "sha256-ZcL1sZGlckqZFhCqTZwMeghP8K9Hee1Zi3N6wZb9hts=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.40.59"
      "sha256-MlMkIgzc2D3i5xAPdk+th0e9AYrvRxGwzl4zwEwy4xw=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.40.54"
      "sha256-qpYLmQ4CfAG30fnY86vT74B33pmD1cDGLHrKiuDOpN8=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.40.54"
      "sha256-3LzaMWu1lPzmKx8+Knc9OdwgElOMumhkt9iEn1gShCY=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.40.58"
      "sha256-Fp2Uu6kufalQEePs8y5DhIaWhsU/GVa723G5TpFAWIY=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.40.60"
      "sha256-iqgdNV7dUDWlDoEZzZiwv+n5hbjscmBc2MrcaYQaCHE=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.40.58"
      "sha256-YC5sNBnH5wS6JSCfPK7cp08WXgBLaDypDRBALMciLQQ=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.40.64"
      "sha256-Gla00GNkoQ9C/AocSEkHQwTK1JP51F+pnhmRfQRFCpg=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.40.54"
      "sha256-pagUH5QLYtbx88TE9470AJOHxG29ALGxZioROq3rqTE=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.40.58"
      "sha256-KPHuiCiseplHyGWKyh3xFSIj+Qet9hsqSva6rmHsFyA=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.40.55"
      "sha256-18sD6lfs5Y9BBp3j8c/TVjI/3KZbO6pKuYPYKir1NQY=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.40.73"
      "sha256-BT2lfTeW8XfolE4suOXWtAqLyyR3G606I4HXGnmp5oA=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.40.75"
      "sha256-BrBxFW5YOucqCX1qlJKF9ildoN4B/9o8P15Bj4X6zDQ=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.40.59"
      "sha256-Bc9v9Tq2eiBAsQeWpK2viHhR/wfP0k48S2dLJqhPjnw=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.40.61"
      "sha256-DAuBN6Sqbs27Gg5PW2V3iTMD3vux5soaFoRfqxgdG1A=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.40.75"
      "sha256-qy7qTRggKgD+0TDPN8voSd+jkfU6kUuVVNZvqlhpIKM=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.40.59"
      "sha256-68cwTIm0FqfkWocusBeXbYnLc7tOFwunRSA0SLxWZ+o=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.40.59"
      "sha256-/b7BGjo6OAzVGJa6oBoFfo1Z0KBtx06KssmMpfY8FbA=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.40.58"
      "sha256-uluvMcbKZz3KA0V7KMEGbRr9CVYIPDhGTTY5oJHjHic=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.40.71"
      "sha256-+hrKUqp4c6sQj3aaT/MXPHsBC2r/chOeWwcCMPjvW+k=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.40.54"
      "sha256-f/tGLKRnpzMDLAzQH1W7sUjGljb04Ws5Tidh8lL0pWE=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.40.56"
      "sha256-idAuSb9+u1KVh13BBNSgXYkqKHZHcSfQ3rVxiDBLdVU=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.40.58"
      "sha256-xQLJrW35xDhr8leBNsKzqfg4B5DQKH8adV5sjIR63kI=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.40.58"
      "sha256-cZzoyjZ3fLtqta684chs4rcACPS19Q1mV1GTaNeRe20=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.40.55"
      "sha256-1boWE6O9IJ1UZyV1NGbGQiHeQ1qFhOxFTnHXCM5Jha0=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.40.54"
      "sha256-djL6fA1ekMWn1Alc3mchrdydGCkVXsDtKNc/fG4xGL0=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.40.61"
      "sha256-nEb6Mfn6FVfrnXjW8EAlpOBFtT3SugCkeH4/loTQBXs=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.40.59"
      "sha256-h1lI/FmzItYTN9lnH/W41v/btpjDdwhEuCnwEHeoxHQ=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.40.59"
      "sha256-P/PcH7FW99E1W5EF6o3e2QamuwcZRcKI6adsbWAmkUk=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.40.60"
      "sha256-3usjCs7VRs6e9oRU7O9YAD8XAjeoL5fFeAPAqpRizIU=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.40.57"
      "sha256-84N2KuK/XAPJqnmeDuWNpC5X6NRodH0luXfP+ZjH0pQ=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.40.63"
      "sha256-oo88POk9T+Ys/awYIRLRw0JwFfFtyyrKC2t/lclKE2I=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.40.58"
      "sha256-8Lxw5GiiQYiGZJkitfEnPdRGw4lOSSF88s8y7hBWnF4=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.40.55"
      "sha256-ldifobuZtba1jApWN5eswPa1dmSvd/a9yAS/wzPxz30=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.40.55"
      "sha256-YYoVn8ECRbtJlljdEaVA4X6UgKiBKpnfq4RSkH7StwQ=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.40.57"
      "sha256-jobSOTxwJ6mzhr4O+opLrCvGuq4MMRe+zjhHWpq4JsA=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.40.64"
      "sha256-hjgvlTcA18OeMpJIgpl+ml4zSc73HXrUrM0adOzScl4=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.40.75"
      "sha256-s5aLz8uOmUn6w6lt6DlksCnTjL+fKcWsTJDAyMnkpIk=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.40.58"
      "sha256-jSoHGhya7mWGoyUCTfLRgqyrmG6TIpS4SVUjSAer0eM=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.40.61"
      "sha256-LM0Sm0mUlnh2R1/TMskPwgYc3OdgFpmmI4j3ltJIUlo=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.40.54"
      "sha256-iuSKo8JCPNNc6FiyKbIpkbVd5rgqRGKOKASwqkCstdw=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.40.60"
      "sha256-I/2vBxmVVqYbiFN/PXCwA/s66oyoG2Q8VS6YTHNrAJo=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.40.59"
      "sha256-Rf6XuOTE/09pKpotR/AY6526gfPP+pP2Y9WAfhBSL6E=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.40.64"
      "sha256-4jXXEaS2Uy+k+FQScXyaLToUC6E3+poejhOLAOGBFdg=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.40.59"
      "sha256-llgYHZUfQTOy5E4BmmA3gAvYi4Q3RjrCtfFm68ECEGY=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.40.59"
      "sha256-f3SQuBhNc2tL3vdqJmoYgnpUICkvJmENShpVbtE7cuM=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.40.54"
      "sha256-pn+Zpzpa5SBhnzzo1yVcQzFi3u3Wbf93AvOL4Xu+yqQ=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.40.58"
      "sha256-cSxcEUfHRBITijZot4XhvijEAfsPWlPu1ZGf6cF2tbQ=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.40.54"
      "sha256-vuOhtYDVqnB4Xn5dzE3N93b7ZWalyvPwTx01CHFzSNo=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.40.55"
      "sha256-PqK4IfA5JcI5Cg4ymR9uoTF3YLs6vu0l0Gl4e7af2Y8=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.40.60"
      "sha256-BizLajwUZznm+ay5QaW39lf61+SGGeR302r0OAWZD5s=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.40.58"
      "sha256-SRvim/6rT3H/OHT1FZRx6PyPUV2GGh5nk83EXhVi5gc=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.40.54"
      "sha256-3c8he41vrrQwW64aGB5ExykWVPqGfj73P0gZBYoqsW0=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.40.57"
      "sha256-n20s8GSpRLcaGXyPJs0KOUwGBOf6a2q22fe1kph/GUk=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.40.61"
      "sha256-o1FsYBeSdq8hcTyKZiCVOuS4XJYk8/8Jrxd+psm0UpU=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.40.54"
      "sha256-3qic3Zk9WZ1JF570ASGt6X6EBeWO4hGhs4kYQZ3RfQg=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.40.54"
      "sha256-5XQk+0F6fX80cEOQlHTZOpcbl2qpaAJOgqawem8kMpI=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.40.47"
      "sha256-BEHP+U37pdHVP7UABWkS3zUYNg+xE6Z/A8mmmd0/LmE=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.40.54"
      "sha256-7h7WswVMGPBf6WsX04+TXA3o8scarCUqnSW3dgUyadw=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.40.54"
      "sha256-YrrEKl3aGz//5Z5JGapHhWtk6hBXQ4cuRQmLqGYztzg=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.40.49"
      "sha256-skz5HFlXRIhqefMOSN8lvhmAuu+COBC/hl8YGJawXSI=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.40.61"
      "sha256-AJOmbZZ199Qtgc7s/TN+Mit2/cPM2dDCmgD1Oz24N0A=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.40.60"
      "sha256-8vUsRFYRMImJyNarFTFLdz0fzsQZLnLt/KV4AGaoQg8=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.40.73"
      "sha256-JeE4QXfg7dTqKQiJiFCEiCgC+GGmGYZuo0mTzLPZNNc=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.40.60"
      "sha256-tPhLjs0Gw9CunnNhnWc9UMyOwY7f1B9V/XzEHOOoLg4=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.40.72"
      "sha256-dlnL+r8PJmkmgGgqjGv4emvD4XqXClOv89krM9n9ydA=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.40.57"
      "sha256-G8yP5UD+srdmTHkuwC5A05L47Piun60kHoPzWG7MvGM=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.40.60"
      "sha256-gvWo0ybabdCa9Y16q85MTR3TIF5VvVJQ0zrnCmkyheM=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.40.60"
      "sha256-4kLiWKy5lNB4Ins3UdzdUOb3DWqonLF4HJWN9mNLmRo=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.40.58"
      "sha256-EHVAJ8ElONBpXvZoXfuL7UbHNOYZyZN6ABHViQg+a5k=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.40.46"
      "sha256-x1BJr6TZpO5OlfAG5l9PuAmfTAMtjnRv3SWO6bh2zPc=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.40.61"
      "sha256-ZKa2t6TPCQBID9YGi6vkYnw9icZQinedflGoqFyXqc0=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.40.64"
      "sha256-zcNW4Ll7oTzeZIL+fV7DaP/YYTjmSzvPhnDukyVFGog=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.40.59"
      "sha256-jYAsZ1lMU9cl4rIvRO1UZLn4nIsuauWrNRwyB0j4HK0=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.40.55"
      "sha256-CoF3Aw759lxUzg9iRCfKofDkbq/idAIy4Eu4L7yrRL0=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.40.57"
      "sha256-GcfGVmcrqgC3MAoqJWrzUXFDr6b9QeSTOP8uCBpnzCc=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.40.57"
      "sha256-EIwRua248SviAlBapRfoxIpCi0ydWw5h5keOZqMA2Zw=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.40.54"
      "sha256-WTZGKD2w3/OW41VKgk/l9KdBnggip8CDTesbtiK/Hic=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.40.55"
      "sha256-lz/yPloTNQOFgT7+FvkxQFFW1bBG+Ew1VVrd718UPDA=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.40.59"
      "sha256-7PNEZ4QfwF9yAl+Fl1ok3Md5FZa2DLO1RIVqIp5CiPA=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.40.75"
      "sha256-9zgwek2AThe58d4xBvD5ECJIXRx/PxFASMpZAaFmJ2U=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.40.58"
      "sha256-eZwpjtTCEt+DnFfHxJCVjBKDxA5qQkBS/1gk0zKb9ug=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.40.61"
      "sha256-JlXbFDyuN/vGi1Oq40+8XJBJJdBLDyY658OPtWC2qF8=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.40.61"
      "sha256-yyzFGMna0sVQnoc/xQSXTMO/RR1RiyQuWHeiVHHk7ZI=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.40.63"
      "sha256-AL/XZLrWVNvZXxHvFXCsR/7L0F+9gCS20AhyJOSk5XE=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.40.73"
      "sha256-+YQ79hmdxbA/j7jmbOibK14rjNZp1uEPFNstt/70QGI=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.40.57"
      "sha256-hM+OvqETv0u6Kk1ZgfzgNWgBTPamBH0oO+5W4hlUgeM=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.40.58"
      "sha256-jmK+l8D36ydnlSEHYxDO/e9XuMp79P1QLdjjFRcFn6w=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.40.61"
      "sha256-zlgDGfhQJcdxNYH7FIUpQJMQ9ytqhn0fbxRm6Hq+La4=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.40.55"
      "sha256-VtcgEoZH1zACZvNGEfy3gDsNVqa3A8JfwTfbd6agL3E=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.40.59"
      "sha256-7Z+kgd+6TYaE5cNmcJi2eWeAsCs0kSv+c+CLr3c9FnU=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.40.63"
      "sha256-QbpaTAAmqvN4Vo6vq3U25bcYLgTGZUTvgaxl6BGbxZQ=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.40.64"
      "sha256-o9l8b3o+Z+ft+t5UBUleHbOfHexY6UBUo10ko6Ru/IA=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.40.60"
      "sha256-ckZ45QZgelh3hVVmMrxdFO0I9qRs8f4EmmRizHB8MVk=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.40.63"
      "sha256-QV0qMR8NdhDx4WR3okTGpYvkosZfD3QslmegvvPyvZQ=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.40.0"
      "sha256-0Ih/hjzLE+pf9dXfTHLli5PYAyRGOTq5ghxNcpMN0RA=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.40.60"
      "sha256-KGx39Si4WoeFHsMTudr3Hmu/eafSsdDXYH2rdUdDbGE=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.40.59"
      "sha256-X3jJvfIkBOC2H85etjD/noBJAuQKuXuH5YHwtQg+0as=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.40.58"
      "sha256-bwX8OJWCayO3dpMuhB9VelSzhl/y+vVch0hY8w2NFm0=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.40.63"
      "sha256-zj7R0tvQvheGrQIAuXQsHBJrm01lQlkoCxkJLZDJR/8=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.40.48"
      "sha256-9lvZvist3G5plkmsvZ4iHM2iBim8V3BmCYTbk6xDrmc=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.40.63"
      "sha256-fKcu/kTLFF/SCXN37pnaKidNi+KxUCnF7FsKTYRucrA=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.40.61"
      "sha256-zATKH97rJDBSc14LaphATdXW0S/4peOEJjK3sSwDk5Q=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.40.59"
      "sha256-iJOjHP6nqOp7LtyEQe3ZPPQVX7hwplNk1BRG3RaFQNM=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.40.60"
      "sha256-qzGok36eKfk+Wmo1m7NEYVJV9GayCjqBT3P++pMK+Xo=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.40.58"
      "sha256-e5n43zgh7Eo0CO6p3m3hC86lk5eAT9gBS8aluLFYORM=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.40.60"
      "sha256-BHmfR+Kx9ZT/xbcXbBrYcraFKPbhZ+uc/1c+IQBiVLk=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.40.55"
      "sha256-B60F/Q2FlLuNCGZuxSZ3A9QSAMFMgFOO0AFLzmTdyoU=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.40.60"
      "sha256-FMOmmPRoZJHz2/U6U5IkMRmDd7XztoqKQKTVm3CAfeE=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.40.0"
      "sha256-ZVrH3luEpHwORa+1LNdmgju3+JUy9/F6ghNzHZUicBc=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.40.59"
      "sha256-n9fTVYvwyPnGIkLjHpALZ1nqZC6XrClJltHicNbgd1k=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.40.64"
      "sha256-G4DP0bpdEItLqe8nNyQIrH9YjaLsQulihQh85yT4nt0=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.40.57"
      "sha256-O+SB0ntnaEzGUHq/GJAE8tCPLcIaTcuWIJ850rv0Vz8=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.40.61"
      "sha256-FtNNtlPc8oYYtOQirjLrLTTz+Tfc7l7dTKTePducOFc=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.40.54"
      "sha256-V6L3DNfXgzQIXLp0ahUw+ILAw6QagJVcZdSf07V9Zb0=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.40.54"
      "sha256-OUZn5wWVxirqeyEIrPgIbBwG2ikudihKJo/WJItVkLM=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.40.57"
      "sha256-qk/18pIl23+NoiPHM39hFIhJx0sTxhR/JJmRf9ePpx4=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.40.60"
      "sha256-KPj/5+bRGnfGct08/e50UhrR14xm+HDYVxoM+U6ugec=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.40.63"
      "sha256-sNbfCSaPWCpF67SQcKcy290OSiMPdHpJsYTUq7uaeyU=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.40.60"
      "sha256-TtEJjbTL9jtHQv1GFPCq2Rli0bhmDCR0OGFZyYZjU2U=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.40.59"
      "sha256-s2zrJxGMHYvWUJCb+4Qn2Ot0qDLBI8wTPpGLy5iUzPw=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.40.60"
      "sha256-zDN+pmptUjq9Cnc6U7mmWqat6PiSWxJibgEuYq1P96Q=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.40.58"
      "sha256-aRgrg0Mpzc+gk2GIPjofavpf6IkMNW3kB+vU6aNelhk=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.40.70"
      "sha256-sBx6B7GRmo0Xr86FmeGIR1YfNVwS4qz18SW46R7P+gE=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.40.17"
      "sha256-Ngqg/OaZCigXIPORzWl8CMv64KPmu8axXSgnBzBWnII=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.40.61"
      "sha256-JRCWcVeatM6XvNH/Rdi4Ny2Clpt5L2aAQjVRRcyT69E=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.40.55"
      "sha256-zer2dqLkBLe1CA5I6+9DavQPvVLtrGFoxi50BRDOI3s=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.40.58"
      "sha256-naC16by9nRoZvRfSIIYJdk4jT/lxqUDeogtGb+q+avk=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.40.64"
      "sha256-KPHmg5J3t6O7SsukkdqnLiNxHpnbS81kPjCD5gxlrzs=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.40.54"
      "sha256-QXykPDFwDXTY44JyYNYRBvG9/rBVmtisFKrmp6UKIQM=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.40.55"
      "sha256-cdyFlcNg9F5RPYJ8xuLm1G1plHQDhRe2YQZqUv+wk8U=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.40.55"
      "sha256-Jzl2BKfgW5EK0GbjUP+BFqNOeEiFvlMMlgzaJxgaFzs=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.40.52"
      "sha256-A93BHo29EHovA2v+hACbOhN+ckTL8JAGgftBBFzXBfM=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.40.52"
      "sha256-Z00yi43t9SMR1hsAG5EkvjaRKLqUU4uYwdn3KVVo+6w=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.40.59"
      "sha256-JDhOF/W9hClZoQDlnYIfAKsU14jyCEillCfq2kqnhSM=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.40.70"
      "sha256-xYZUp/3OmWJOhaZDH1XkMYKTlJN7sigeviLNVsceDX4=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.40.54"
      "sha256-6usEXd0rpBSaLBKHawPIiPzqfHoNCGVO8c2p0eBqrvs=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.40.69"
      "sha256-pzWCGZbQ6idUKwNWxGyg45Z4rRzdReADX1u+934VmEs=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.40.64"
      "sha256-6hFX0XgzB+dMqyaEUJQADjivNJH71oD4KG4KulkqRjE=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.40.60"
      "sha256-bbhNpZd4H36Ai5o0HhLJaVTmteMwswzLGpg4huYXQCQ=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.40.70"
      "sha256-xN2jcBDaBrSCSreVg8S5mtN6tx6mfoyDiXEex8VtSTo=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.40.55"
      "sha256-oD/sVVMrRUBW5brBaCyNeNfHU4ZAWgfiqcgEwTxN00c=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.40.59"
      "sha256-ZNjp4SzprutjypEz2lNfVl26eaQa42M7ihnyoxKjptE=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.40.57"
      "sha256-12d4SbtVxKDSBedA1F2VnopqBKowjuIKboHZpIKEwAc=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.40.57"
      "sha256-S5/42kRGzK1BTxE8Sp6XY93kljykbQK0YYCwQM+sJxY=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.40.60"
      "sha256-tdinxlqaJt7S2m87xb82AlSB+FgrKSuFZKcGIfbNnUs=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.40.61"
      "sha256-/N2wHasgisfb8fVCiKsNecyTZRGF7e111qr95hYEIac=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.40.73"
      "sha256-fMytWYfB05TBtTGKAF4/VBWUeuEwVApBe4BFq8mAkpM=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.40.61"
      "sha256-FEAlQu+9Ghddr4peEO6zbhHM9LN6/aJZ/+tdMKHH8bM=";
}
