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

      src = fetchPypi {
        pname = "mypy_boto3_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [ boto3 ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [ "mypy_boto3_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for boto3 ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
          fab
        ];
      };
    };
in
{
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.43.10"
      "sha256-oB2v3DdKFxhtwJ974/vq5UIJ9UVWCPMCAJaDNl2xTtM=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.43.57"
      "sha256-wIu+Vhh/OnDbSzvZFC7VP2IGvYAK5ZZ2KKfNKIgz3h8=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.43.71"
      "sha256-24QBYMB1qkzU/bHWHz03FngomwqTAcSK8YlQ5r5g8DE=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.43.65"
      "sha256-M2L+W6/5g0v6RejXtkEJV/H4991u7P2gqN3ZFt4QWxU=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.43.62"
      "sha256-h42x1hJbjLtZrYis16d9HkcASfrFAkboeedwrwOthZk=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.43.76"
      "sha256-lqCUosJ/5/SjJJEuHRRGCR9QeyQEDa4+Pf7jPtVxaUo=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.43.0"
      "sha256-dfL8YonjWmWI+U6VsmXCOTmfo3kIUPgOKCKT+/q6b70=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.43.0"
      "sha256-XrlXdqhPSVWqssEe+UuREy69icRZE/wCxvM5KVnHS64=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.43.0"
      "sha256-LoKLFyWsPkSm4DODnXkpqzblQse4osUJLAetitR+/VQ=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.43.0"
      "sha256-2Y8XmI/8Y/nMrCraK9gqkOTiPgfrhTZ77fm4Xxbxsrg=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.43.0"
      "sha256-MzXtUHNFCx5jRkcU4PIh3xIs6A9jNbORcdls/3UjQIc=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.43.43"
      "sha256-vptHQtETj3TU1HfzmK9G4T0kJDNaS7UWlO8nlb9WfHE=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.43.0"
      "sha256-lXABSpVWIFB3Q+Zrk8Xl5toHs5tI8UbHq8ayWas51WI=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.43.0"
      "sha256-orCWB6FeVF4iJiIja5hNW14PZ/QUGaaRUktPr7dPgpE=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.43.23"
      "sha256-7QYZuOxO32+VYpWBoDlOBYhRHP3bVBLChVmor7tuyuA=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.43.87"
      "sha256-wcejwfqmImH7RWgI4nCLdCYHkVLfAu331ZzSic4nR80=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.43.33"
      "sha256-2XP/4KieF/WxpTNef7md499zt0eMOaQ6WiwEIObZEIo=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.43.56"
      "sha256-u/iZOkj1XF/MPuhzn3Dl75N5ZkdGa9E4yAjY9vrWDDA=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.43.0"
      "sha256-RTA5W/ZbYVewNvnS9X3ZN7cO4+m+nwewKRhqP80OJic=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.43.0"
      "sha256-oEoGMnF/+BU62mYNnh0Aoj89AZkk6iArw3pCTV37ld4=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.43.0"
      "sha256-gJM0o+V8YnmwVkgnRzR+Peaz45JuRpE8Hs6LRwfTeUQ=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.43.55"
      "sha256-nxkMmEP6tX2sQWwzwrSvP5fxEwNrfpG/jY+lg1knvOo=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.43.0"
      "sha256-kHjAZUMhXV5jTPswlMh0Y3/V7R99jyuknh5sqVWb7Ts=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.43.0"
      "sha256-yVYalO7e/czfc2dsoN2aEypJQMCPclY/Gvo799FYBsU=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.43.0"
      "sha256-0+/67dkC+suDivd53hHJ+d1D8Kg2ZxRJvUS0EUaZjXE=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.43.23"
      "sha256-0QMHGUpHVdAUf8hw4RtgU3wManp26riDDbx49a9929U=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.43.80"
      "sha256-cKf7AiygDC5u5F7FP/0L0hqQ6WpNvu3LzP6fIcZIF+M=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.43.0"
      "sha256-imuX16TqfUAoPqzJTclvPMWiVnDSh6nJ8QbSksLEKps=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.43.78"
      "sha256-kERQjzlMwcmJ6e5W/7Q4qZuK3Mix+Q9Seel2xEf2AZc=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.43.55"
      "sha256-EMl1KCe3/wEmsfTPgMbzDWo1V+NakqzhZJRPYNadeZQ=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.43.79"
      "sha256-3D1VN30a3RNbVUIeu2T2IBH18327SHca+LzmqbUec8c=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.43.7"
      "sha256-BWFbcDtacQzWwN0fc+OH/iSbsE3Lw0xAjn9V3/Lbxws=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.43.0"
      "sha256-yVV4PXfWEkxmy2qlgQtcs3iIVo6mzwKY3i2j/OLsf9U=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.43.15"
      "sha256-7xusmV+Ub1MkH3mGGYNQFlI1pfg9v69OzN2FUN3+DzY=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.43.22"
      "sha256-1CgG2p0ddlGj4jttaV9ejP+DA7cRtAE56rJwMNPCgYw=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.43.0"
      "sha256-wEKvEv5sCqZ8urD6rF2FxbhnT+riado4SMkZb4GTjZE=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.43.0"
      "sha256-UFQbNUX0qbRtX3VkmgMJPZyPqcj51+Of1C/RJdvSyjo=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.43.0"
      "sha256-XD0O/cLPR/0dgH3PUQRnwEHW2iGGMqPuxdEk7070hmI=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.43.0"
      "sha256-5MeFYmCsBP+KN7t3Q0UZxF/Yt3st1wXS+bpHAj04Fi4=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.43.0"
      "sha256-tzV4iGq77gV+G8V29kn3qq9Riqa5TqDObBi2uVAXpx8=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.43.50"
      "sha256-Ees/nrPLKM8p6FqVewgRkC/1w/8kZrDGgxUb3AwDgeo=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.43.71"
      "sha256-8JDXNTdGbq1n+Lsoaf7pfQEti+whMs8tx8PO9AFrBqI=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.43.39"
      "sha256-n+O246n0LbH1Tc8QK93YRO2Cxj9pz8nfAetvq1lidj8=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.43.0"
      "sha256-KwwGrKpyWEtL6cqtQA3TjWuQodCGETNCopw9GCQE4BY=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.43.69"
      "sha256-iGWIsG2t7LS4gMbNAVPyarrc8qmhtpleps/OhDInY24=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.43.62"
      "sha256-dcBm0aFySX9u7mKe1+RHl4faTkkpGU65ef6ocxGAXhk=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.43.76"
      "sha256-ODAlvUNrCOza4oMMwhSnO2xBuUMoqMjCxmNBPkTk/jY=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.43.0"
      "sha256-TgO3rIefF/8y6hBV6N8pxK7JboMBTFWMK28sE/WvxyU=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.43.0"
      "sha256-iWBFQhEfZEsk/iHFMz2q3FvZqY/DeOcgJLLMbcFtD7Q=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.43.0"
      "sha256-XWNJ5/MQnUSXTAA5Fa6MYxXj/ygw6tVjnTY+Nar8vU8=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.43.0"
      "sha256-uyv85XKo/8MreIxPhVtrocfjYaYEoW7ppWT50LA1dv0=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.43.0"
      "sha256-4NRQ3ZuXmsb90QTVwt57MneonBWDQjNj1lD3UnqYAOg=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.43.0"
      "sha256-PVskBSuwqSfNybHDtLLfVpDG0dwR/Q1LhrHz1imsR8A=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.43.78"
      "sha256-gPJbV1Dmthocp49ENiO9ND7ewUTuAhXV/nAsxkw+UGA=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.43.0"
      "sha256-CubsXd2HL6MvlyE5z1pnAacMWILCRnlWE0cZODrVeJk=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.43.38"
      "sha256-Gc/u06NkA6juz5ji9jPs3Z8xp/GVrKEwhFqL0jGedaU=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.43.0"
      "sha256-wslSfhGAP7FLmfRb+9Ez1eHm2kYScWzbm1DjaH9t5Qk=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.43.71"
      "sha256-YnE8vRO1bzaGSCHM102N3ChinXrxj2/+vnHqst4pPbo=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.43.82"
      "sha256-WpKfZ0zeDn0qXnw98ATlOrBpyjWTx4YnGt11bNqVh84=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.43.0"
      "sha256-XVttoZ5ZrLYKhKipByY5DS6QkCn8hVkvOpv7LDfWrA0=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.43.0"
      "sha256-3AUfJHKef3RMi2bNCGhbuLXz2pLnRBkwxaWgTipPW2c=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.43.0"
      "sha256-4N/7oY35YL5yhAJV48w6Gn3/vqy2D4i7YRVM4RrpFME=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.43.0"
      "sha256-NGqIXvyBN6ryi91iyVsCHiIP2YYWT10jfjymR2pVOfE=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.43.0"
      "sha256-RRk2nw7TiXH6ktFN96roZ+XS/iu1F6nmqNM9rPZkccM=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.43.0"
      "sha256-QIdgZzTxbWIotkfHQCUxc7SVrKUReLJD1Fs+R+97Is4=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.43.0"
      "sha256-CavBKgp+dEMR2poR+bG2PgZb+wX1zlNmuOyJsV3LfVM=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.43.83"
      "sha256-M48OOjCyaCfwjFOIkxhae9E7ZOVf+1MeikfNqsxtuOY=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.43.0"
      "sha256-EoEbHL7mVL92u2sEuQSC3duOm6XD31EBGMeWmRhbXjE=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.43.0"
      "sha256-GCBFy/aUd9tlvFe+gqJJ6WTXybWI0T6bQRx5PTd9M6c=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.43.0"
      "sha256-sXIPfVu+Ss+UHCZ7W1qof+rbEb266dqrSU3V6/j5PzY=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.43.33"
      "sha256-Y+cDD5dq7C8tiGW37YheNcHTMxFyYCX6P6JPSjN7ttA=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.43.42"
      "sha256-3JYcWKFk0dKJg/qn+EBvxeAO5xh5PXCU3dTEWDr1oXI=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.43.88"
      "sha256-nwCOd292NPwPsLsrHRg29a2MRO+Hh8h2H5WK1xb9CdU=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.43.79"
      "sha256-pfKiLx6qZJxvFGY7Jm+355d1fT4knIoZYD52VtWn+ck=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.43.0"
      "sha256-diymNW6D5QCBts8lrsxQy1Q18+LeRkhtOThRkd4gWsk=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.43.7"
      "sha256-lGdrTkjAWbH6kBppKKLFrMyL/UiUwzpkClbWwTkl32E=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.43.23"
      "sha256-bPHo+9k+bZeVrx6ytHiat8ienlPMqmmtei3waof4m4E=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.43.84"
      "sha256-1UynYUWJBNAR7XluHvtbnVo9GJIP9srcFXuo/f6wGy0=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.43.0"
      "sha256-pi0hMLpgYGrNU0/infONBg2WmES6NV0tfPgTjuRtWXk=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.43.84"
      "sha256-hCHv3nS06HZXMyQZrgboaNOw++iwDBid1z0BJ0Bpie0=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.43.0"
      "sha256-/+SVztnadibGuzLO1F6hOvPTMOCRq7iaA9Bc36KUzUQ=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.43.0"
      "sha256-OPnECfEDg+3xeJVSRN61zMJcKvDfPWvcS0elJNEG1jM=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.43.0"
      "sha256-KvH54NWvZxopuZFYYIbZxASO/WbO+ng7Wd7/sr+OTLI=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.43.58"
      "sha256-mltqDnYt3EXm+2jrAUp19EkmwOb6jaGzDPB3orecWMI=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.43.0"
      "sha256-enqysaiJ2TY8K9Fya6ih4kW8Yo9LSbI61NT4G5ywjTU=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.43.0"
      "sha256-cQqctK2DnuHUuhMb+07M60JkyuBveerK2ybTt4bM+kA=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.43.78"
      "sha256-KLcJ+s1kHHTgH/42bNXsPP6s73mvu+8nWqHlGXLq+78=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.43.0"
      "sha256-4VGCEZbno4w3H5+bc+2/f4ZkgefUDgWOOBkuGTVqvWk=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.43.76"
      "sha256-QjOdr+p3TniXH/86WJJm+QbePgDSe8iek1eq65g60E0=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.43.0"
      "sha256-+JRa3rx25BROhc3oXbMEW44C6aBj5hK1upz8kqU4MAY=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.43.0"
      "sha256-jkgV+/T/mGbAFQh46ZYBLTM66Rtd762XUUsbcFciJkk=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.43.59"
      "sha256-BBZGru4kpqUd00T5fpc41jobbUyp0zVQu1tfWw4ZAjg=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.43.0"
      "sha256-C6J9oFEXb579bPb6dONRUrB+QVOGuHLmwpV7EsE8qlY=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.43.0"
      "sha256-67KqkSc8oUjKhuvQW6glmb211JZd+xkF03Mt8FISE8k=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.43.88"
      "sha256-NiIdpQFSOXIehaU3CHmbAXKQtN987CKXS8rALs5Yd84=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.43.0"
      "sha256-LE8moRJrwRp3T4UGkj+vdRyq9Qw7t/UxcQm1Dw3/Dfs=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.43.64"
      "sha256-hZfd19X5LPAOeqCHWZPlzwmYjwF+70G5TUfAjnZ1tdA=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.43.0"
      "sha256-iSYi24MTQ+NNQH1e/bvJMD6NVQ/qV/OY49SSpTLwdDo=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.43.0"
      "sha256-dXNkOcMonYrBh4yzeubd+v3mW42s9XpmpfvgbtgoJgY=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.43.87"
      "sha256-lWEOo0WCiUxGL+z5qaahIlsuqKjxQZ4WEotCYJzRQQE=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.43.0"
      "sha256-xJQTd7AglqOdFW1SuEV2Hr7BbDRhzhmmWvLg+k7Ie6s=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.43.73"
      "sha256-2Ow59L5miqnog1xPNszG/oMu4tJOfePiYdxpGGRiyQo=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.43.0"
      "sha256-02BUkAFhr9sT8ohkJJFPYNni0O9/UI/G0GUee/Kx5Dw=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.43.88"
      "sha256-ISRYYfs2nEW/dt9uqkVz7ZPshfO6VjZDfw/iDP7hqlQ=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.43.23"
      "sha256-11KpPRxGId76g/I4jXwMQ55kwGEQVsasgvMUXsiLbM4=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.43.88"
      "sha256-SqRuidD6RQLjGow/AXhpvYiM5+tkBBDBT6F9nAhHs6I=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.43.37"
      "sha256-jD5yROkLZtZrSX0MMSTs9sCjNRs97g/T2wuDmnu1VWQ=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.43.0"
      "sha256-tfFoITPeC8GybrrYdo49Qmsr9ZvAWMuvFmi4w8HIivw=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.42.3"
      "sha256-6fH7Mf2p9tYmendYBCHXKo+6NKkRP2j2ofLTrkxlrtU=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.43.0"
      "sha256-ft2sKNwhMdRhms/ZXOetpR/gnB3YNYGsbQWQySagk2E=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.43.88"
      "sha256-gwGI01weMHiIFmvWL7AM4Dva6Qu2k0o1jADy71MvKcQ=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.43.50"
      "sha256-D66oOKwsYwhgg9w7o4i9H1SIodq10uf+qif9kjKBfi8=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.43.57"
      "sha256-oLO6EZ4hWQSuYlQ0dML8FsTMKtxTCtGehXI1NkmLO34=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.43.24"
      "sha256-VTCKMo/iFUNS6n3Ppl7jf9YxHPx0+IpU1atVh8KOgR4=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.43.74"
      "sha256-kvrpSJ/opDyYAyGrVZzHxKFG78wx90Glha7+IOMwg3E=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.43.47"
      "sha256-5oCX/SqzPteV6nkys8NQXuFB5AX9VURIidU4MBmJil8=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.43.0"
      "sha256-IVuNaG6bdFqGQJCTHR382i5JvsMjg/iH1YCixGSS3CY=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.42.35"
      "sha256-kdSGsikyLazIdSKidTt6bk5i+syJgx/GE0y+KRpC1rw=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.43.0"
      "sha256-CjVX0pF3be2BNpJy/+zWJ7/YZSszPlLWgIL/Qo7jKoY=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.43.0"
      "sha256-bPKKphp64m4s7ceo0ypSfyqY/AGzqFkIWQksqDIRLSM=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.43.29"
      "sha256-TSU71JWgQCd1INc/OtAtCkMzt1V8L75GRWEx630KfPI=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.43.0"
      "sha256-r/8/UTc1qhymzpKf/F3hXQlA2tMZBwd4JmqCio6cFdc=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.43.0"
      "sha256-+MaSBJxS/iQ/6veTEuSoJY5vaSDAaXsaJwMyW00wqUA=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.43.0"
      "sha256-3Tzd2aOwX4q+v0qi0sytq45o1/ynJKi6zupG5sGPIQg=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.43.0"
      "sha256-i22wXb7ln99O04Ks/goZ9TV+GEDKmtCXekHw+umTBzk=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.43.0"
      "sha256-C7V/8x9FgRwUaudSDWK9+VdHoR0Xcc8l4W5KzFTKzDk=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.43.0"
      "sha256-4roB3AEdN4zXGceUNkrmarmTThmPbS9SltvHG6kF+84=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.43.66"
      "sha256-ApoGnTCfa7+GhGRUWWUStE5ad/gZQpCvGUd8ugcZh1g=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.43.0"
      "sha256-xywLVBOF2ZfCHFXrTSZmlWCrzOLkVW9elRSSiY86u60=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.43.0"
      "sha256-vMz4YKm78XMavlPUNiSVAYmAbyUBrJhUXbFrhxIvUJA=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.43.72"
      "sha256-RVRPMIAv+0iaJxpv/Xnj8dPt9HNIIOfPNe4yTQqspVI=";
  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.43.11"
      "sha256-XJOSLyL1+uEweZ9zER7IhH3DFLaLtpJKvuRIn8Ri+P4=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.43.0"
      "sha256-Xo93GLmd72kiV+e6/f4+gHdEdeMO6C8ph37wKweEl+U=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.43.0"
      "sha256-kw8ncmITgoIGnWIOk9X3S8klQ4B56LtH1CVLFKwA2ic=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.43.18"
      "sha256-+DDeD9YWo98meLZU2Mzu5AE0S7HFg6kfxeUWUh9XcQA=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.43.88"
      "sha256-UjHoeDHvr2QKwUQ2NEMoE38Lxa/vAiUNmJqp1XaVP5Q=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.43.0"
      "sha256-UHDodWN6MLV54LA31Pc7vlMr7a0tVrmCfVjXl96cjsE=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.43.83"
      "sha256-vxuW61ChfpsrGZK5eKcQsURk4oG29AaJJZhmrWSG6Lw=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.43.70"
      "sha256-aL9OaJDsqudoUtUBCQuP0LBDhCQAkIKiC/5hL5PeKPo=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.43.0"
      "sha256-9lzXp7Ug90MSZ7WdMiXoMnUiaAA9zCk/oS6gc0ulEMo=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.43.37"
      "sha256-6NLOcq8lrMDBgl+oaPrGSbPaHzObGq2vJYzPnNQFMCQ=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.43.0"
      "sha256-UPfzmcKh+ZgETuak1eYRQEyKke20BW5q0Os62mj5D+E=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.43.0"
      "sha256-9P8m5QYikdsimepaivrYcb/tP1iThyPZWFMkyo24+bo=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.43.64"
      "sha256-7xAA1OyNETjna5Yehnnzd8u3OJF8P3lMsBFE0/0tx/4=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.43.0"
      "sha256-F+4rmr2/nI1TQCFnMY0dPxAXlgN3IBSfiQaDGup5HSw=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.43.80"
      "sha256-98iuZorHk2BZFJDHPViQ5LRnPKr5W44YvxJ11SvcvKQ=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.43.17"
      "sha256-ZFp6f51JV8wTk6CBNLdl4lNkEy4xA027zxfYQdCICa0=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.43.0"
      "sha256-ai2rWv+gAsIDUgdXOlDlDUIKdwwYIjIWvy2Mks4b06g=";

  mypy-boto3-iot1click-devices =
    buildMypyBoto3Package "iot1click-devices" "1.35.93"
      "sha256-fwfuhSitYIJW5QswYdZ8ZpNL3AEg6MXhJitbbU48STs=";

  mypy-boto3-iot1click-projects =
    buildMypyBoto3Package "iot1click-projects" "1.35.93"
      "sha256-LFuz5/nCZGpSfgqyswxn80VzxXsqzZlBFqPtPJ8bzgo=";

  mypy-boto3-iotanalytics =
    buildMypyBoto3Package "iotanalytics" "1.42.3"
      "sha256-KnsQjmsXPq1VOsgdfPQ8NpXbXJ3ed3nQ6u4xd5SvGHI=";

  mypy-boto3-iotdeviceadvisor =
    buildMypyBoto3Package "iotdeviceadvisor" "1.43.0"
      "sha256-bHz1uxp2Bito7mcs5VBTYUaI3VmrKnSvtYcPjHIOwbE=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.43.0"
      "sha256-vrbVRBb2BCGTG+0hth2BQVmF62R/ufvrXHYfl2L9R/w=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.43.0"
      "sha256-UMcPVbdXrdQ0MApotjGVJTMhJABvM5sOU9liZSZJWBs=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.17"
      "sha256-SeJi6Z/TJAiqL6+21CMP6iZF/Skv1hnmldPrJpOHUfo=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.43.0"
      "sha256-LTEwiPO3NwdWlo4X0JJxjsQ95xpvpqPb6Wb28CR6ZOk=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.43.0"
      "sha256-han7AMRHtSLHVlPIBwAS2nGanHHiPTov2n/ayLZmC6c=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.43.86"
      "sha256-iFMN9NfxG/rWjiNLe0t4shJoaSNma0r2gKAJKoxvN+k=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.43.0"
      "sha256-nfRWM0Zn2keciPpMsqWSCKITeJg1qZ7j8Q0+r0Gw6is=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.43.0"
      "sha256-v5cHLJTqCyncFbrEz5dFN4PEsQ63cVKXKj6jwllUpPU=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.43.43"
      "sha256-qQXnIrnOoUlp+n1LgymG/BFm8IwtAJyc/YMJYRdCDpw=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.43.45"
      "sha256-VAswBdekr2GBDzQviuu5s6ixvA5R0IGMEYP2dpuxdJk=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.43.0"
      "sha256-0rzVOt5tK99dXME4fBoww2DsvoHEIQ/KXzBxSx3ShXY=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.43.0"
      "sha256-9XMdnVsYUmz8Uf9kAgVMbG960vy0TOJturoD9/ZoM98=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.43.79"
      "sha256-kgfPSlNO0uj6Az83Bc/p3uyjqI3VMgwK+5/6tRoY4ok=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.43.84"
      "sha256-HmtmND6m3dv/AffBhlDhiSmHpK2npSttt7RvwtrFnqs=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.43.23"
      "sha256-zrQQQNejq/o1IQTpwQO2roa5RYTegdkRxPsmEEZKCFc=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.43.55"
      "sha256-nRuz6nALSuBYT+OsbwaktaXj4g7zX6l3YopEKtwH1vo=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.43.0"
      "sha256-f36IwT8zw4RvLqbZgGas6euLVdKR5gJJl7eLBF8PjaE=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.43.86"
      "sha256-ad8diP7891WECwzfbFMStIqcBNeRChyQ/euFIQX7asc=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.43.0"
      "sha256-yfOcuzek1G6SBO0/iKrcmi4/l2KlE1a35gf1UdmbKEE=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.43.0"
      "sha256-bmd/SlahjC1HKvg1Ac+4m2RtXiNvDjJ1drGqTLXF8ak=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.43.0"
      "sha256-P5jFW3ANT/TZQlFWPMicvTDOmZIBFauHyqocXSE6JJw=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.43.0"
      "sha256-a9G1wZpyLWHd1QM+ySCYs5RBZNGWJBttQhrrjTTb7v0=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.43.0"
      "sha256-mFybt0ZyAZIvW5UoJQxxDGAALawLzwGJqE+Y0YOPQC0=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.43.51"
      "sha256-K5TzadxKcWP4pvo0JJBnl4zIjzTXfasROX4MIdoz5iM=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.43.0"
      "sha256-SjI/irHvvEjhPyjQcEf1VAWM80ZLH76EFs/1JFDuTi4=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.43.12"
      "sha256-pNI/AYQip5vEqIZnb2PrpUipiwb13NA5XkJNfEcus0A=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.43.0"
      "sha256-gYTCgaRwH3zKi6gg4MC8DUwXQT+jZO6lqc/vi+JUahU=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.43.86"
      "sha256-izGEfjbs9na8nsDO79EUBRaCF28opTMqMcXCuSA9KbE=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.43.3"
      "sha256-RDdJKx7S5CxGQDtW8AGOy3JEn0slMu7yws8PmeSLh0k=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.43.0"
      "sha256-1kE3yNQBw8a1bYq3xMfAEfqW2p4FduGQ/uAJjI81xds=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.43.5"
      "sha256-CMdW9o3nNWkgsvP0lB9cBlpx8li5Tl9pZv0grrMLPus=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.43.0"
      "sha256-efpFIYAdYkvWBlj0tLsQagps6XJfO4XLjlfwKS2vi3s=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.43.46"
      "sha256-WYv6TjbNNEhrumvLT1QPBgaFUP/w4+7a5gY63n0tjmQ=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.43.0"
      "sha256-zoWGCMfhDKcnoU2LWkGbwy+17uoqDgLaqiEH3ohb5+E=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.43.81"
      "sha256-LKXGGLE2ONJ1vthSqCnz8TGiFcQNm7SaGel51JOXkTk=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.43.86"
      "sha256-VelBFE3vkDl2ILcwnI/zzaJVxDbyuY+TX+LkkQYV0lk=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.43.0"
      "sha256-EunrKwNaYp0CDiwp8frI7zASilMF4wYHjDSuCsJ6aJM=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.43.82"
      "sha256-Ca1ZfLeVQnqAPx64KOwG85MIPiow/pt2ACndNR4xo3w=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.43.0"
      "sha256-2LImXNFMIsFKasOZhZxAbVx4XiX0TiuffDRJ6LgJaHI=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.40.15"
      "sha256-ZcL1sZGlckqZFhCqTZwMeghP8K9Hee1Zi3N6wZb9hts=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.40.59"
      "sha256-MlMkIgzc2D3i5xAPdk+th0e9AYrvRxGwzl4zwEwy4xw=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.43.0"
      "sha256-7coHyMnmbrLSRi3/7+x54hOj3+shCS9v8OFvOWBIKrg=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.43.0"
      "sha256-MBstuygQi7eZgW3qqEh5Mu4tK8lO5aiYIg623z+DOEQ=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.43.0"
      "sha256-I1rFY/t0hwRHhnASQvNIvd/dVolKYrMHv70ch+0V3Hg=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.43.0"
      "sha256-ZsalJBzTODl1ba6QA0bj/7rrZ70DNro4PUTfrowYepw=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.43.0"
      "sha256-ce8c73a1ksdQpCN6cSg5KMkbVqomFNyZnaf7pag9wBg=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.43.74"
      "sha256-CK3AK9+biR+TIqNIrGWoKCEnpnVyPKTDvzhpwo2fOc8=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.43.0"
      "sha256-j8CGEyfiQPa5ZvIoZdyzGrLnxbb93+uXrufCdkmiI2Q=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.43.0"
      "sha256-Ob9sh8Ng8I3sWiy/qwu+lfSvf+W2KQiprWX6QCNiSLM=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.43.70"
      "sha256-NKaLJpv0Fx1Af3AWW2nWtAyCmoSBDMZ+JwZ2XeYHzJY=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.43.86"
      "sha256-y1tuFi8DkMioVdO+YVoE4Bp23d8p8Ta9XkauKMF1dEU=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.43.87"
      "sha256-kh7MPWYuuu6Khc3dDGUHsSuWXl4NI9TCUIF5msIfPJk=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.43.0"
      "sha256-OPbU92VvD3YPihFUl00xa4PWvIXUy49CqPFGGZXxAt4=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.43.0"
      "sha256-5AqWiNGz9jemWb8dZkuGQXxPXIruMdDWcoRzbT+ZGro=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.43.67"
      "sha256-zgO/4TSdGI7TDa1diqAQ7S56T/G7vON5HoTcIxSv/sE=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.43.0"
      "sha256-tT1iRnm3gOaY8clsRshI9NL1FF4aHlBhWyJMi/7HpE8=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.43.0"
      "sha256-8K0Xm6PMo+daS6xt4kBqaVvO2/LruFV7PVvugI7sNDU=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.43.67"
      "sha256-KByjjBZAkDzURyVPfYAgESJXKrHQFwqIKJHfuGbV92c=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.43.4"
      "sha256-I+MxmW/fbfF3uX+EF2P+w6y62gndgoahOjfSm/KoX5g=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.43.0"
      "sha256-13fAVct/Icy2iWt9z+fFyHLbp+7X6kZjLCtiiqC8Emc=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.43.80"
      "sha256-XFy1jhIJAzgEIrRNermVRAlw/ly5IPSNfm6Wa1wgyfs=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.43.0"
      "sha256-V6xgiUn87wqIlWJGOpc7Zu24EDzROAspAn3qkRifsFU=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.43.87"
      "sha256-jLNkOBQ1j7LMNQ1jLTMJx6v67FYsNwlhNvezLZIvxuU=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.43.0"
      "sha256-PIgHi6/xkiAjzrvgRgh6b2dLPTGoVnvd3xVLAW6nTCc=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.43.0"
      "sha256-InMFJXbw+lFAqmmjeCs8v1ICBrvnIJb/0xKRla/FVPc=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.43.0"
      "sha256-Qzuv+hkKiTS26EfgCkzV9FSgL1LCYhsT5nx1xdAQG64=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.43.0"
      "sha256-Xn8quvaU8HAJKLiUuh7vGqy6j/VYWrrdwAEuMnFSdzw=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.43.48"
      "sha256-ALT7Le8lS4EXFe1a92z0t0iT8aYKOxJS5EGic/7hwC8=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.43.0"
      "sha256-Igsngmg9PeJcyqX/Ih+fgzUuBotaf+2UWHK9RKEePL4=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.43.87"
      "sha256-ZhOFMEuW4wICCHkvbcc4r0EC1LT7yjvPXAqRF1ytzs4=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.43.28"
      "sha256-igWmbkUqAiS+kCoH5DV72SaVD1eaX+70V1HcYnTGXfw=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.43.0"
      "sha256-rkVxsY4MQ+eB3uQhD3kI7bBpCHiDVcQDNUXA5zUyeok=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.43.81"
      "sha256-93nLSPE+OKe3N/df3wEouufPXfJTCBVrZkPmh0EZvAk=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.43.0"
      "sha256-UYfkIUzPjS8+9WjqbyHgzdLODOloASlx0o+ETyjksXQ=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.43.0"
      "sha256-BUl/wnJKR3TB1YsTCLrJdEoH9Lz8DZ6H94STOOX8gkQ=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.43.50"
      "sha256-ZZkrP2naO2AVonXdkY+ZCQNV1LH0S7F34OuWlpuJ+8c=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.43.82"
      "sha256-Bg8eOFGWb2ruPwhQjTHoBzCnj8/ST+sSjW8RrzpRtc0=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.43.17"
      "sha256-NRfAfDljMbFnYHaUgTXModL5L9LLZDVMjBisQVHYC2Y=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.43.73"
      "sha256-ez2VbSV/c+w7PWp9Auu984OsWe6JvN50PbKvZsvg1+Y=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.43.0"
      "sha256-0rAEnU+3VsESGKlu8OTnY//rzwRqvROhRFga+vnwd1k=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.43.74"
      "sha256-+aD4yYblbA96r2oJ1Y763jap3RDqMarKmAX9POcMBos=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.43.0"
      "sha256-DDNWvmo+i3O3s8sL16zg+QhWYzfrSTPOBHni8PVOgbs=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.43.24"
      "sha256-R+9NhCyUKOhMZCyWll1kilbBGlcNfpqEXgQVskDo/nU=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.43.49"
      "sha256-7qCpo7OktzpZtZosFM9e1ygUPhcYFmShD67ngrG5Wf0=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.43.0"
      "sha256-vAaiVQlvQzF8Pmmletyj8eWJ0oWeh3BFsLz4yJDP1Hw=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.43.0"
      "sha256-YM3HbNdW4xYvsJaiQ0MxAOo7bTHXbB95jNwyUBqV488=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.43.0"
      "sha256-G4Yi1ZVrkTRZYIHoWGOITtn0aUTiInKICGYr+0Jdyw4=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.43.0"
      "sha256-jA+JYi8QNlcBHN594d4Iur14ytDdg7/G3pXIWdvY2Yo=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.43.14"
      "sha256-9mNS3NKDG6eBciLbBd+mweeP7FULFjl9SNLW1vrC0go=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.43.0"
      "sha256-nMG7mVx53CqENoZ2AJnvMbzn+ZIK/Tf1eeBc8PsJ50c=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.43.0"
      "sha256-KPqjClzMa/GzS/PHI5l/TVCbTmZltTAS21kr1BTAR1g=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.43.0"
      "sha256-A8/WYxFn06rUXtcIHsKfs7HxvOBges0wDGskm31NIyw=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.43.84"
      "sha256-XGCMvA6cyzMNrJ6uMVV2xSRmZnPA+Kyfjdr68B8LTU0=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.43.0"
      "sha256-5bmcUB1MIxJ34XQSsE41OrGfhy8c614AZenIWM885v8=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.43.0"
      "sha256-kD3REDwAHOj2eFUwzEPmrqjFaqj/mF5urdyf5QvQv/Q=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.43.0"
      "sha256-bj4/jUE8pkOLIiC1um5TU0AVhc877vWZndeixsxMthc=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.43.0"
      "sha256-zWR60l2zlboeCCP7n9wrx6j4R6/jfnrBkWaT0u669pc=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.40.54"
      "sha256-7h7WswVMGPBf6WsX04+TXA3o8scarCUqnSW3dgUyadw=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.40.54"
      "sha256-YrrEKl3aGz//5Z5JGapHhWtk6hBXQ4cuRQmLqGYztzg=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.43.84"
      "sha256-8HQGvA7/CTOtOwi3H4zyfM9CugpMPrAsoGq+2LoRgKs=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.43.0"
      "sha256-7IRVzeDmUM7LceRhz429R8RKeBJEQfVZ96FIHQmfh4Q=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.43.0"
      "sha256-ZmYC3YQujmfSUK0pOGCGFwT7LrSa3oJfo9juUb+2Xpk=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.43.82"
      "sha256-MSD/jBLp2KsVFRermRmbvWPJyblS5KqzSUD5X2l5jrQ=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.43.37"
      "sha256-11kfuBIlPjrL6NdBeo+23xYQfL9eeu+C7Gfi2aorNDI=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.43.75"
      "sha256-5qI1H2mPuyqoz1KmntNcGz/NYxJnq4Cj4m7CZrzo7qU=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.43.55"
      "sha256-7tnl8u+aOsURS0nIdDto8EpGaylEVX7jub12yo66PZE=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.43.75"
      "sha256-qPiRg1TifdbOHPT1gOUJhvfMm/4/LMwiLAU/3FWrE/0=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.43.0"
      "sha256-yrq9Pk5zgOWfsYakcPdA0xqK+QVI8mRV2j3iy4fqBX0=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.43.0"
      "sha256-q1NTyAk8F3hQBeh23YBA/416Xr9Di0xGfGm9fqzmMTU=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.43.37"
      "sha256-hY4oe6Uxfs4ZIUEGLddEVh5WPjmHmkk3O5qpAObR3e4=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.43.0"
      "sha256-cI7cDSHrRZj3RTYVHJ/6lYqz6qgYUPIlc4VUeSW7xIY=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.43.15"
      "sha256-8WMmFh5E1wdCmf9CIZscwj724oMIa3BNR+hwWHnC6TM=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.40.59"
      "sha256-jYAsZ1lMU9cl4rIvRO1UZLn4nIsuauWrNRwyB0j4HK0=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.43.58"
      "sha256-P3eG/eC4WOUAQ4phUPjN6uZrN9GBYiaGkgUsGIITgII=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.43.0"
      "sha256-Lva6G5n+26LxafVZ2wcZLgZYiYYnYwVM1E/jJkEiAUU=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.43.0"
      "sha256-LRvMiVOd/1BFnQhN+NR573WjuALNpCM4/DK7NC1h5GM=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.43.0"
      "sha256-upsBu22q1OGGkWaKk7nd+csGSyJoNdp8JZvSHHOU/U0=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.43.0"
      "sha256-4DYUxjIUCC/NHV5BRkeUNXC8wVF1rUJCDO3VWxubtjk=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.43.4"
      "sha256-F1xhitFa4Eac9VlCpfqjCObUH+YvLz7TYDYfI/bPYbc=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.43.31"
      "sha256-MXTtc6xvYB6K8S4XSt916G5jjv5y7Zzjp6HnxdfIdZ0=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.43.0"
      "sha256-8or7NMBfeq9jZRzAu0Q1ShoTXTm8GCXR4kov0kaJCcE=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.43.66"
      "sha256-svdHY+Nzs/PWTPzS8AzbHBDIpM7+bUzbwe1Kat4IXAc=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.43.17"
      "sha256-egiSBx7pwuiEVoqnIXFyFa8vZwNCirohoYTIwCF7L7c=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.43.0"
      "sha256-T+JIJpHxD7IzAwq8yxgq6zbVMj/btpbhKnylMyfFvvU=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.43.87"
      "sha256-iVyD1REh/KEqP1lB3MmWgSo6kShwiLIgzABR9SABSdI=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.43.0"
      "sha256-jnUH8nHt54uG7FBxZx49prqx1Cc8DzNDgwNiL1QHeIA=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.43.0"
      "sha256-wwBlAR8kwqMGpHHMmXTUD1jW8YvtMl4lRR9KTV6RxME=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.43.87"
      "sha256-XkRHzmjBHdNHQwwOS62vbJPTg2kKFuokOvXO+qUsxvA=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.43.0"
      "sha256-qU03CsCdINIbkUWWZyJbWe0lcuw/xt/7P/ahMhB6afw=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.43.0"
      "sha256-OxrliFuV8nojK9YroUDbJAUt1eECaLeW/Nnww0+iU5g=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.43.68"
      "sha256-aMnsrMCq0pwyRsPAzuvGVCdDFYNooHv334jmMcI5Mz0=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.43.0"
      "sha256-UdTdVjxyxI4cZR13CjCtP+mj9EvH+pwB8lAYfNPWFXc=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.43.0"
      "sha256-4i9uiELT5+lZ6QJKsggSda/gxpKOkuwiT7xI4URdL68=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.43.0"
      "sha256-xg8JYWDWm6+Xr0juzrrfkh7rmQDGuU7Rtdd0z55I1cg=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.43.0"
      "sha256-CW9tYiy+Um/VTlnt0GhJvo/BSPnJJ5ILEPwMAhraHvY=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.43.0"
      "sha256-Jl7i/d+dPkKuOWhWJft4YaU5EQ2OMkNyhHwOHL1mayA=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.43.66"
      "sha256-zuv74XGZqO0OXvAKw2yCd48PgFrmZilmqEPOJrTTPu0=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.43.0"
      "sha256-pwyBQN0XXWN83ccE0gbCcJE8ozPn2pNMgj/nEOo/yq0=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.43.0"
      "sha256-UWNKYI0t5AzHph0jUQEc0R4NJT7izkr/pzO7k14LfDg=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.43.0"
      "sha256-m025z2loWJuRtVezRAXMZIKXMu/V/7cFxghxIOSLLQ4=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.43.0"
      "sha256-J1UnC0SGqnPl1qjGh6gDaLBLa8OW2YMZtGJ27zQJcmM=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.43.0"
      "sha256-tX0woQcWoUOPKxSthE9p2rs1gsiA57DJY4JgreeAt0c=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.43.48"
      "sha256-F0UEyBR8QZyFfB5REL9P5z0zsZNhcddgxksj/tE+GXQ=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.43.0"
      "sha256-JO9Mm6dTJuFnbyRzuSaPpT2lvDNaSUMlspWgeH+bt5M=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.43.86"
      "sha256-L/UudSinoZd88xoNdyIGqiKZiZyNe37q9vqNzteIqSQ=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.43.0"
      "sha256-Pd/d8Fxq1HQsGeiGP331Ss5RFNQA0W3HLU0B97llPZY=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.43.0"
      "sha256-O/moShH3i7avL5pzZ3NnmAwMAm0UUFp9g/TVTurpKzk=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.43.0"
      "sha256-Uh/EREUJuFFWw3ObXhDSWgU8DXRi2znVgfWhMhnhE0s=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.40.0"
      "sha256-ZVrH3luEpHwORa+1LNdmgju3+JUy9/F6ghNzHZUicBc=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.43.0"
      "sha256-fv7WLk2Kbrw8niNgGfqx88TZQVWbm9lUgyL2NCDitIE=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.43.0"
      "sha256-wXdXItgB+AgAXYF1KWJvn6XfFwdWXQR4RG6LknRlobM=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.43.23"
      "sha256-b4oZtkxqvxvWI62Rvn52zifyOW2h8QgwWJIdDeQXatE=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.43.0"
      "sha256-Psjh5lHoMK/89/4VGy4wkLjqmNc8sGkFOwnKTH9MhjY=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.43.53"
      "sha256-8govEDWg1YthZHxvXIg+BYFSrNzNipfn0ZFkdtyOfHs=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.43.0"
      "sha256-fwItFwvc3+G8xmDVqtSJqbEi6fey6JFFeNILLOsYOQA=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.43.0"
      "sha256-o2eCfk7QZjKSv8Bm8AmP3BL6M4QGVJrz8oMsmbF/yds=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.43.0"
      "sha256-Kd3EQQ6ZjEyBixSeXFSiPci9qyk/NuFP46O7jH8Esuc=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.43.0"
      "sha256-V1og1LY/ORrXbfFVs4vF8LYe30/kvG71F3rWwXmNSJ4=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.43.64"
      "sha256-wesA1gX4AOwwJs5LKmr6O+MZV8mJFpGh/Gh1wluUvgk=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.43.0"
      "sha256-rMrmybKplGKYPFr1cIQaHRs/bwcKFYlFWCQRe7PxXOk=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.43.88"
      "sha256-CfFmSJQ5iH8LIwDpEBzUacftP5N8cyE7M/YNxcp6SrA=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.43.0"
      "sha256-Y3p6SUr/Ej8SiWm9Dk3ifaxF3vesKlCdglgIcoJDemk=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.43.0"
      "sha256-fDjP/Q8H/yJtC4AWYQv1+hm9b6KnWgTP3uy6LKvqikw=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.43.84"
      "sha256-idAR4rzgGjV373VLw6vB6GBK33GawNjNMVApo6YayUs=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.43.0"
      "sha256-/B05S4INFBRdthN3+ybnXQdzIWwldRKEdfdp4ngJKUs=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.43.0"
      "sha256-EGelGYE1b7seBg7WHOnY1Vumlw8iMqBAMIuUpPmIUIA=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.43.45"
      "sha256-WEz+PMPa1ojI7uyLyMq2s5P6u19uBI/8pra73oWsyKA=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.43.69"
      "sha256-RclJXtzfxHLiV/GLiIuPP553QGUC3BtI5EbiqChUbbs=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.43.0"
      "sha256-fCQPZ6Vb67Fc3l70/X2w0AhhUyz29PIBpTW49nfhwG8=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.43.0"
      "sha256-eYFkK6WzRSoUVnxhmQV6WGsnwS18+1oZOKPatxUPDBw=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.43.0"
      "sha256-fc0e8DEx/b6M3kPB4Y07qqqMayg2BGSQ69gkuhcrl9Y=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.43.88"
      "sha256-j0jjna9RrTHQRzwwJ8tR82161XXYRc2CJKWYzninfGA=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.43.88"
      "sha256-19TDWG2CxiHrVgT9TrnEFLYU/PhjtxkOmGfeQi2KG8k=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.43.0"
      "sha256-3gP5TN3PkxdmGXMMACoCASgaJnlRp1hdnzfHRLjYiWo=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.43.13"
      "sha256-TtndYsK7U4b9f1LWtXadwD3SyRPkx3uhjRIGYxybW1s=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.43.0"
      "sha256-OY+yyrxn5dKgzCjYvHp0oVlHY5i9zSO0nS7zyotc94o=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.43.75"
      "sha256-ln+4NojNDTN9K6AZxKgOsEPMRb56y0A3Px0XAdq5EZ0=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.43.0"
      "sha256-sbQAgZlIVUy728L1TZOXvTzxmp4yvzswgMXJ5ieF3CE=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.43.0"
      "sha256-zwxwpve6uEpXNyMQzaFPIEqDI/JoP5ks2wmO5gqLf7c=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.43.78"
      "sha256-KXzvLywcMSxSswUbgqdJJBMBuQ3O4EAk3nuX+n94ONE=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.43.70"
      "sha256-1keASWD6rDl/MuQDcaxfPZlN8U5/a2K7sFGdWLwrrEE=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.43.0"
      "sha256-Yyltlus+qxQqAzzi6P5yXElnn2tXaEUtB9lvobTGFBc=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.43.23"
      "sha256-muQgj+irB5ZQw+tIsWVUlUljC6uWT5D2BOXcXPf/Yeo=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.43.0"
      "sha256-AKgxPXa2diiYTDxZf6x+UAaDPtOK2RGTbG/p3falJ6M=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.43.0"
      "sha256-2glzIKBlui8YPvzI74bT4ADqEZ0lH9CuZqHtwz64Z3k=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.43.74"
      "sha256-HG0Y3tBGBKrwOSmFL9Nmx0F99+X5MnCi0+gQkgtqTD4=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.43.0"
      "sha256-u4iLZ4mf7rRJvTpbroMyLfAQ8Y8StMpIVXFGkVvv3l0=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.43.0"
      "sha256-aIAPLrlVqF0WatRitflWPL1tBXiEWAcTfJPNP45w60Q=";
}
