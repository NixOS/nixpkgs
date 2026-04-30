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
        license = with lib.licenses; [ mit ];
        maintainers = with lib.maintainers; [
          fab
        ];
      };
    };
in
{
  mypy-boto3-accessanalyzer =
    buildMypyBoto3Package "accessanalyzer" "1.43.0"
      "sha256-BwX8ieQDuKQ+ZXvGD+INPX6pS6qvqewhj8Ttfi1Rs8Q=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.43.0"
      "sha256-KNFTnweHO/8xVFHLcjBP0USqBQfc5BQjj+JBEGlM7kI=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.43.0"
      "sha256-GGKJP2yX4n6n0+K/LmSSNbpeb9e7b194L9pg7yO3WAk=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.43.0"
      "sha256-o5hZAxSZklg7hzL7MWCBYnnYTRoBSSAKPLpub1NVO74=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.43.0"
      "sha256-yDDyrgINiqUb6lcpQI9oWDy6lw+NiJR4hwmxnAPpQeA=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.43.0"
      "sha256-+NcDF7OKlkYfnuGf1IyFMr4XsLWSet855TSoOzsRuX4=";

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
    buildMypyBoto3Package "appconfig" "1.43.0"
      "sha256-JcXo/dGd0aeQzrJFC9scPHKI2Tna+PaWLWVZwC17igo=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.43.0"
      "sha256-lXABSpVWIFB3Q+Zrk8Xl5toHs5tI8UbHq8ayWas51WI=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.43.0"
      "sha256-orCWB6FeVF4iJiIja5hNW14PZ/QUGaaRUktPr7dPgpE=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.43.0"
      "sha256-AaezdFSoG0JtWQBOAd1f3gUhtppML68j9NvePYbjsdI=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.43.0"
      "sha256-8nS9kfOsFIRMoiF9Iy8czuGCBV1JNF3AHyMjIjcvp3U=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.43.0"
      "sha256-f9Xs8j/KPZjmNJaifdX1Pi+oxliZHAeX80q/qXUURv0=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.43.0"
      "sha256-nKvPnx0AUoi76f0WPMV0HhiKwgYJslxM+OP+NQAN2fA=";

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
    buildMypyBoto3Package "appstream" "1.43.0"
      "sha256-FWmLbsuieRRvtLtGYEvA8qx7lUmA28gcqBwFAYKEu7g=";

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
    buildMypyBoto3Package "auditmanager" "1.43.0"
      "sha256-23zuWICJ49no8T4AlgZV0kDkz0j5pe1xE7uKKmszm9U=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.43.0"
      "sha256-8Wme8qFuxcX74RuNmGl+9mszIpPXh5bcttMRoeqN7ww=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.43.0"
      "sha256-imuX16TqfUAoPqzJTclvPMWiVnDSh6nJ8QbSksLEKps=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.43.0"
      "sha256-O3fCM33tfF8mxS34KUEQLz4OAV9rSkAtVEcYfd1MBJ8=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.43.0"
      "sha256-FZuhcgbPBohluThfTy99inR5nyG0r3q/AsxNEvtgJU4=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.43.0"
      "sha256-qkYs/jiXHYUjQMXSYx8XepvxFcrwRXYp2OUJNual8Jw=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.43.0"
      "sha256-M1CIE4fho0uGdF6/h87BCiz7Y9q2P2nAHC2NS/d9JOA=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.43.0"
      "sha256-yVV4PXfWEkxmy2qlgQtcs3iIVo6mzwKY3i2j/OLsf9U=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.43.0"
      "sha256-KXhiiIB9ydHdwGClmYbaaT4t2sA7BdEXQG9HFpnuE1w=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.43.0"
      "sha256-RsvQvkie+k0OMjgs30ZlwiRygo0LhZk0V7vMAXU6gQ8=";

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
    buildMypyBoto3Package "chime-sdk-voice" "1.43.0"
      "sha256-Vtu56EDQljvG3JZbiqt3CJzhquUIbYY2/Kn7QXw4Poc=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.43.0"
      "sha256-iQRlqBZZG4pnuy57HXKwFYJ64+wkS9v7h/pKl19R5sg=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.43.0"
      "sha256-76N3xUFKaU+cepHviRw2SWdjptNmVZkg6giAF7B1b5s=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.43.0"
      "sha256-KwwGrKpyWEtL6cqtQA3TjWuQodCGETNCopw9GCQE4BY=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.43.0"
      "sha256-Ula0Hx4jZ6JVlT9v4P88bmtQSYyFtofeZiN9vAILqxw=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.43.0"
      "sha256-W+hFvD3Buc29i2sHH618QtAiHUCHrAzHxbndIZsyRgY=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.43.0"
      "sha256-VdzeLDZ+AC5tqngdlPsKI8QvY+DlruTKcpXL3z4lpdw=";

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
    buildMypyBoto3Package "cloudwatch" "1.43.0"
      "sha256-jVUV51R8Yc8QyvjijYo1uyRPgTBpyZfsVVg7/og9f/A=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.43.0"
      "sha256-CubsXd2HL6MvlyE5z1pnAacMWILCRnlWE0cZODrVeJk=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.43.0"
      "sha256-2w+09jNgnpl3wQSKfnz7vsaQBVy+puyOsvimwa/axgg=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.43.0"
      "sha256-wslSfhGAP7FLmfRb+9Ez1eHm2kYScWzbm1DjaH9t5Qk=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.43.0"
      "sha256-0g9BWShZat95aZvymEAJdKsKjZhSoye/YBi7L2KauPo=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.43.0"
      "sha256-lFLE/ggwLC/ZI1f5woZTJadm5T1XBDWd2BmuqK92hC8=";

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
    buildMypyBoto3Package "cognito-idp" "1.43.0"
      "sha256-oxmjIvweCKsN/QybmuHCKeGPzQMZsJOZ4HXvUnA15h8=";

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
    buildMypyBoto3Package "compute-optimizer" "1.43.0"
      "sha256-6fPO+EuWQP7JbsVfMzpCr502G0ewx/pvubEqEnhhln0=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.43.0"
      "sha256-kPG0jzeHlRm8dNKCrxJY2Jw/N06PL+C/34gB9qhz2BY=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.43.0"
      "sha256-M1VhBDYXAvRDV8U47BAeP0zlr7d6ZClYwEkDUUy35fA=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.43.0"
      "sha256-7rXsHj0fTM5UPbdvtGH0AimOjKbrrSZwW7pueKjF/uA=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.43.0"
      "sha256-diymNW6D5QCBts8lrsxQy1Q18+LeRkhtOThRkd4gWsk=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.43.0"
      "sha256-4rq7ErTAeExDoq40tL6gjEsQjvGfOhUGuiDBoVOw4vQ=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.43.0"
      "sha256-q+pbs4ZSKslCsusngqG7Z1ubXLs+SLIrwywLR/fkGM8=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.43.0"
      "sha256-TvuQwrUio7zZucfmOwDGJskn5cqZB3Z3I1CELx/ZnG4=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.43.0"
      "sha256-pi0hMLpgYGrNU0/infONBg2WmES6NV0tfPgTjuRtWXk=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.43.0"
      "sha256-P+3AG1/Dj29UUJyAfXJcLvBxnLq6miVReVirg+/ewks=";

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
    buildMypyBoto3Package "datasync" "1.43.0"
      "sha256-GAjsb2LKpwkD4+GEqxUbGlQR4rXzMxAGP6WH1j1y918=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.43.0"
      "sha256-enqysaiJ2TY8K9Fya6ih4kW8Yo9LSbI61NT4G5ywjTU=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.43.0"
      "sha256-cQqctK2DnuHUuhMb+07M60JkyuBveerK2ybTt4bM+kA=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.43.0"
      "sha256-vwaHsbqy5/hS/s+cNGvjldHffDpJ1Gx5nBSLKwvBU4g=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.43.0"
      "sha256-4VGCEZbno4w3H5+bc+2/f4ZkgefUDgWOOBkuGTVqvWk=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.43.0"
      "sha256-qoADzGwSCK2RXSaZKirR5g8SQBmDUuQtUGRdCv69Irw=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.43.0"
      "sha256-+JRa3rx25BROhc3oXbMEW44C6aBj5hK1upz8kqU4MAY=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.43.0"
      "sha256-jkgV+/T/mGbAFQh46ZYBLTM66Rtd762XUUsbcFciJkk=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.43.0"
      "sha256-SDTUIwYwaIa8GTCU4P6x0gjZcjVtv+fY39ahC6rnYDQ=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.43.0"
      "sha256-C6J9oFEXb579bPb6dONRUrB+QVOGuHLmwpV7EsE8qlY=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.43.0"
      "sha256-67KqkSc8oUjKhuvQW6glmb211JZd+xkF03Mt8FISE8k=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.43.0"
      "sha256-1cKleN7L5xTlQCPq3OKiSQcnkeooPKS1AqIg1sBXOMk=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.43.0"
      "sha256-LE8moRJrwRp3T4UGkj+vdRyq9Qw7t/UxcQm1Dw3/Dfs=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.43.0"
      "sha256-8M6jjgWPHQc2HstV2PQGZdgktCz0hkckx/zMi/OUb80=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.43.0"
      "sha256-iSYi24MTQ+NNQH1e/bvJMD6NVQ/qV/OY49SSpTLwdDo=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.43.0"
      "sha256-dXNkOcMonYrBh4yzeubd+v3mW42s9XpmpfvgbtgoJgY=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.43.0"
      "sha256-JBWWuBm6ljK3xfOVvzTHucAK4XVN/KZ5l8rpZRjgyfU=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.43.0"
      "sha256-xJQTd7AglqOdFW1SuEV2Hr7BbDRhzhmmWvLg+k7Ie6s=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.43.0"
      "sha256-tsQBQQYNC3qMWW7jwbRz6rVIfh1R/5Kh/xHq9Y5zf6s=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.43.0"
      "sha256-02BUkAFhr9sT8ohkJJFPYNni0O9/UI/G0GUee/Kx5Dw=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.43.0"
      "sha256-r2UhnI0quhdur/l/5LxlaVSwgDYQGdR1KdwadfvuR2c=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.43.0"
      "sha256-R5CFa1FuJ/b361hpJx0c83RI0ZI2Vk3oflTP2CP6WsI=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.43.0"
      "sha256-GH1+EVxXPMZWHDbpi6D9Xucz0tlPucjRvjDKd7wR4b8=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.43.0"
      "sha256-6NjmoXMu9RDobyrdRWYVNPc6Q8JDLP+TzAsy2z+ELgk=";

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
    buildMypyBoto3Package "elbv2" "1.43.0"
      "sha256-duh/9/eUhdVkmkEgdf5EB5nbp/TlXQQLMMAorlYPRu8=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.43.0"
      "sha256-xp3QbOVif4Z9QbnKUHlPbIWHxuXzecUk2bb1Y1/ekH4=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.43.0"
      "sha256-fvFFfq6wf98uG59Zb4dQFIx+i+NH14zn94lX7jwKPkI=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.43.0"
      "sha256-2Ly3Ty1hw3U5NTRf1KCIw4Q/1WSD7pFEBafr1JiYLPA=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.43.0"
      "sha256-OW2ITDZlMSCnCMlfCl3lBMTMXRhahVaSIoOX70hX6U0=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.43.0"
      "sha256-I+9aGV6qURFYoHe2rNdk+BfcIvN1lc5Ot2G04F7nGfg=";

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
    buildMypyBoto3Package "firehose" "1.43.0"
      "sha256-3y8ubLM+XkcUxBxNt5QUocBDLvzVaAY73pqXfCSr1mc=";

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
    buildMypyBoto3Package "gamelift" "1.43.0"
      "sha256-WGFXXyxUTvKbPbJnkAxcn5LbCzN4hTJ/5LhyTQZI3+s=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.43.0"
      "sha256-xywLVBOF2ZfCHFXrTSZmlWCrzOLkVW9elRSSiY86u60=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.43.0"
      "sha256-vMz4YKm78XMavlPUNiSVAYmAbyUBrJhUXbFrhxIvUJA=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.43.0"
      "sha256-37wgxUoswgRZGpTYplXtIjyBEwO57aEzlcTOwg8g/pg=";
  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.43.0"
      "sha256-ciXs8g462XTc+GTyxuGDDEsoR9DMD+bOdSUFe0OLshM=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.43.0"
      "sha256-Xo93GLmd72kiV+e6/f4+gHdEdeMO6C8ph37wKweEl+U=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.43.0"
      "sha256-kw8ncmITgoIGnWIOk9X3S8klQ4B56LtH1CVLFKwA2ic=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.43.0"
      "sha256-nTKK7qqa2apyNM4/U2AphLGvoSqemVKfpAciilJ0pRE=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.43.0"
      "sha256-xLN9980fWNie8P+lPG7rKbvIH3qsuioPnnwcB/HDnlc=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.43.0"
      "sha256-UHDodWN6MLV54LA31Pc7vlMr7a0tVrmCfVjXl96cjsE=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.43.0"
      "sha256-YeeEfYiM8ZJxcmxk6an+uCan9sMzYN4SWiApLaGCyzo=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.43.0"
      "sha256-qAL1Um+zThQZnOsQcTvFXGI9GffSzbQ9e8G1Ak3CtUI=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.43.0"
      "sha256-9lzXp7Ug90MSZ7WdMiXoMnUiaAA9zCk/oS6gc0ulEMo=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.43.0"
      "sha256-HHmkU/o6zilpJMmpvE6hWmHw9hf2dJFFctNUjsjbGcA=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.43.0"
      "sha256-UPfzmcKh+ZgETuak1eYRQEyKke20BW5q0Os62mj5D+E=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.43.0"
      "sha256-9P8m5QYikdsimepaivrYcb/tP1iThyPZWFMkyo24+bo=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.43.0"
      "sha256-ddF5Z3B3NMKoM1RUWFQzUQTnBL75IwlVevM/R2bO9OI=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.43.0"
      "sha256-F+4rmr2/nI1TQCFnMY0dPxAXlgN3IBSfiQaDGup5HSw=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.43.0"
      "sha256-SngqqN4Ccm4i7KhhFBU1eylZG/7OlGkzqiynEG/7m2g=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.43.0"
      "sha256-JqxgidIcq9qZ7CzFWIRYC+vWTpzbOs2n/0ZfYTPkfPg=";

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
    buildMypyBoto3Package "iotsitewise" "1.43.0"
      "sha256-pUKqVV5J1wMo40qRdxo8ckLXleoHu6OA8F6X2uoqq1c=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.43.0"
      "sha256-nfRWM0Zn2keciPpMsqWSCKITeJg1qZ7j8Q0+r0Gw6is=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.43.0"
      "sha256-v5cHLJTqCyncFbrEz5dFN4PEsQ63cVKXKj6jwllUpPU=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.43.0"
      "sha256-CAn84uzip9Cd8Xr33gxAx6+iQ9hRYPO0u718BtYCr84=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.43.0"
      "sha256-wGqp7Kw0TuAOd9RiOzEFUujuWnPTfEdWcjtNZkT/VJU=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.43.0"
      "sha256-0rzVOt5tK99dXME4fBoww2DsvoHEIQ/KXzBxSx3ShXY=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.43.0"
      "sha256-9XMdnVsYUmz8Uf9kAgVMbG960vy0TOJturoD9/ZoM98=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.43.0"
      "sha256-YqJsj6xyhNz9Xwdp1YkHimx2whut3tIff9SmRLc54Aw=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.43.0"
      "sha256-FM/OFQLL6E/ikP6PIFF7sMwNjBoVfufLWH99tL/B7xA=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.43.0"
      "sha256-7zx7u3kh6NiBuL7O1nlbg0oxBnPSh1HMRnyTrf/AyV8=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.43.0"
      "sha256-IHb9mlWLil3R/3HakccUY/4ewEKVSSpRcySglLob3MQ=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.43.0"
      "sha256-f36IwT8zw4RvLqbZgGas6euLVdKR5gJJl7eLBF8PjaE=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.43.0"
      "sha256-VRGpxnoRDh17SvfHg0mHwlCShMwKrkwqPHtXJoFlJXU=";

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
    buildMypyBoto3Package "kinesisanalyticsv2" "1.43.0"
      "sha256-0uyfEjT25rn7SJ+5g71VRnq38+mirYXikGE456DAuKs=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.43.0"
      "sha256-SjI/irHvvEjhPyjQcEf1VAWM80ZLH76EFs/1JFDuTi4=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.43.0"
      "sha256-x7burzJDYflPJr+SFtUMjL1DJ0qwRHe1GL79TCZBWDg=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.43.0"
      "sha256-gYTCgaRwH3zKi6gg4MC8DUwXQT+jZO6lqc/vi+JUahU=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.43.0"
      "sha256-pY3ia1wTvlTeqzFyPumreqqSK+HfvQk9w6TKEsyFMVc=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.43.0"
      "sha256-IaCx86fBpIsBp6ue8uE0z3U3HKeq0fDhfJVmPDsiQk8=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.43.0"
      "sha256-1kE3yNQBw8a1bYq3xMfAEfqW2p4FduGQ/uAJjI81xds=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.43.0"
      "sha256-oCXwBVVHNBIlBTn99cxrpkj/nUWNk4NReXsLKRvlwRo=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.43.0"
      "sha256-efpFIYAdYkvWBlj0tLsQagps6XJfO4XLjlfwKS2vi3s=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.43.0"
      "sha256-DGbHoepZkxN9ICxqnda/6mBJxiTH9X8gU/wT+xMGs3g=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.43.0"
      "sha256-zoWGCMfhDKcnoU2LWkGbwy+17uoqDgLaqiEH3ohb5+E=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.43.0"
      "sha256-kCI94Z4gBIthwj3Q7OqdIYPPWqavxLTKY3FQDeuPsmI=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.43.0"
      "sha256-HA4SqeZxi+iSD/WcokROHaCQEUGAQhEG9FghFEdUWhY=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.43.0"
      "sha256-EunrKwNaYp0CDiwp8frI7zASilMF4wYHjDSuCsJ6aJM=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.43.0"
      "sha256-rqx+8C6S+zdg00iiWgMyeSAQTOPuJEZIJw81xYbu5iY=";

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
    buildMypyBoto3Package "marketplace-catalog" "1.43.0"
      "sha256-NXmJGktOefYDVoA0Ah0YDRPvgCfQDv/BwLqbQijTUdk=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.43.0"
      "sha256-j8CGEyfiQPa5ZvIoZdyzGrLnxbb93+uXrufCdkmiI2Q=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.43.0"
      "sha256-Ob9sh8Ng8I3sWiy/qwu+lfSvf+W2KQiprWX6QCNiSLM=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.43.0"
      "sha256-OT4bGX7DaTrMuzEdK71GemaeWzPa7MbDd4+bApuPZLw=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.43.0"
      "sha256-jiYmf0SWN0WBh6kJRllwmPMgcZyCxPRuP2GD2DavqKM=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.43.0"
      "sha256-9qc29IQF9OzXua26/slmxeeRMTvdX1kATpvuLJvl4Yk=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.43.0"
      "sha256-OPbU92VvD3YPihFUl00xa4PWvIXUy49CqPFGGZXxAt4=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.43.0"
      "sha256-5AqWiNGz9jemWb8dZkuGQXxPXIruMdDWcoRzbT+ZGro=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.43.0"
      "sha256-bGxwx1LeiPWn6gz4Yqu6pIQ7sMgCro5W4oO/Wk72gok=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.43.0"
      "sha256-tT1iRnm3gOaY8clsRshI9NL1FF4aHlBhWyJMi/7HpE8=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.43.0"
      "sha256-8K0Xm6PMo+daS6xt4kBqaVvO2/LruFV7PVvugI7sNDU=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.43.0"
      "sha256-SIcglcosop2grZI1DjyHKURX/DYA7RSGGWQ1IvsYFFY=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.43.0"
      "sha256-dq7im8OpCHkvqXupdBpwCfDzt+WORF9DB82u9OHQ484=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.43.0"
      "sha256-13fAVct/Icy2iWt9z+fFyHLbp+7X6kZjLCtiiqC8Emc=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.43.0"
      "sha256-+gJkfsKfgRQbXovoZwas++rwAFxKlkGUdjqVGgE9jvA=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.43.0"
      "sha256-V6xgiUn87wqIlWJGOpc7Zu24EDzROAspAn3qkRifsFU=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.43.0"
      "sha256-YpSyhr87CmLo2+LGQzXU8q9uZt5YiDm23Ukpdh8eZIg=";

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
    buildMypyBoto3Package "mq" "1.43.0"
      "sha256-fZFP/qF24Wssjh0RDXx4jBfCIGZn0OF8AMJ8e8P2yfU=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.43.0"
      "sha256-Igsngmg9PeJcyqX/Ih+fgzUuBotaf+2UWHK9RKEePL4=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.43.0"
      "sha256-w9AGeJrbRrTD31ANqKy6+MIQKenn05akYLfsXfnOw+w=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.43.0"
      "sha256-++taPLvX9mWzlCBHtr3pLVPWUT/WcFdtCD73pxoDqjY=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.43.0"
      "sha256-rkVxsY4MQ+eB3uQhD3kI7bBpCHiDVcQDNUXA5zUyeok=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.43.0"
      "sha256-23FKHmxHWa7mgIWe0SRxbBzO6LZNdNkaU1XOqqI8knw=";

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
    buildMypyBoto3Package "omics" "1.43.0"
      "sha256-by5t5x+vu84vjqe176tFcz1zhDUIsmUo6dH5f3OyWOw=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.43.0"
      "sha256-rQRJE32K/Ds/q8bB8FcrTcPbPc6NXBVvcI2TJzXJSbI=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.43.0"
      "sha256-XrDuzW9pc2H2PS3h6rI781j9knG+ERTdEvOigumtZug=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.43.0"
      "sha256-v72X9KJETKK9ppx1It9+5ywwEdtHRRBmj8GcSJrOBCc=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.43.0"
      "sha256-0rAEnU+3VsESGKlu8OTnY//rzwRqvROhRFga+vnwd1k=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.43.0"
      "sha256-fVKNAX3cx9jeCndcQYyxp9lgqHL91yFOg6dX/kNv27Q=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.43.0"
      "sha256-DDNWvmo+i3O3s8sL16zg+QhWYzfrSTPOBHni8PVOgbs=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.43.0"
      "sha256-+pUG2ANTIw8W6hoH22GIrz00bdsHKcB9yKSW5bhV0e0=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.43.0"
      "sha256-Npyleoivecba7q9HyHNFRjs66fwNGR5dsAsu4e51luo=";

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
    buildMypyBoto3Package "pi" "1.43.0"
      "sha256-V61eo3XMqDqvZzPltRq2JMjKhJUnv1AhOn2/xHPWCEo=";

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
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.43.0"
      "sha256-gkNI9kZ0fOLazbkKBu6JHlwiCmhk28WfL9o7FFj9f5Y=";

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
    buildMypyBoto3Package "quicksight" "1.43.0"
      "sha256-2u+DpuVv/U/yXXYf6i7+ID9Va2m1y/tTOkJAcfAem6w=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.43.0"
      "sha256-7IRVzeDmUM7LceRhz429R8RKeBJEQfVZ96FIHQmfh4Q=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.42.3"
      "sha256-55wnvv8vd/G5KdZoJipaSLzC13wRoop7ZXwTLDU4GtE=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.42.90"
      "sha256-qdm9TSIVwVqMWYNt5rHnIGqof6XY4nyGK/VsrtdF1mc=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.42.3"
      "sha256-XHcwFnP9i2zw5yPwvhcMMCSTmBpQy7ZdxQ4eMR0ao4M=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.42.42"
      "sha256-hQyZdqznZ8uJVoiwuiVRQRG8fDVWykuyWGJ6BOEc0bE=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.42.87"
      "sha256-KjFXEK3rcYOgaN1unw0mFxqW8VKPzsYT95KQO4DTZp8=";

  mypy-boto3-redshift-serverless =
    buildMypyBoto3Package "redshift-serverless" "1.42.28"
      "sha256-9sMbueRSG+9HdUXt0qH7L52J4coYQMV3ij7z9lGJJb8=";

  mypy-boto3-rekognition =
    buildMypyBoto3Package "rekognition" "1.42.3"
      "sha256-1WBI1Q2LMnerRfzoo7iohiE+KYEhz6HZqsqq2U7jvWY=";

  mypy-boto3-resiliencehub =
    buildMypyBoto3Package "resiliencehub" "1.42.3"
      "sha256-fijgv07T/uckhzTbyzvQ8IzbtaYyz5QTeHGl3w4+Sko=";

  mypy-boto3-resource-explorer-2 =
    buildMypyBoto3Package "resource-explorer-2" "1.42.30"
      "sha256-KP7USy0B599a9Z0R3LwpKeb/XpjPUde3qe2oNH87xR4=";

  mypy-boto3-resource-groups =
    buildMypyBoto3Package "resource-groups" "1.42.3"
      "sha256-e2HQgjT94ETQuVS6ILTxBrVVbCmFb1pRo0FLiSCSJ4Y=";

  mypy-boto3-resourcegroupstaggingapi =
    buildMypyBoto3Package "resourcegroupstaggingapi" "1.42.3"
      "sha256-9UQvGxwF0vqxM2EXTneV6yIZrPI28EukXE0qi6lWivU=";

  mypy-boto3-robomaker =
    buildMypyBoto3Package "robomaker" "1.40.59"
      "sha256-jYAsZ1lMU9cl4rIvRO1UZLn4nIsuauWrNRwyB0j4HK0=";

  mypy-boto3-rolesanywhere =
    buildMypyBoto3Package "rolesanywhere" "1.42.5"
      "sha256-KsxXc2bn5flyurs3oC3PR3LgaiC6UpBy5+2JKFhnSPc=";

  mypy-boto3-route53 =
    buildMypyBoto3Package "route53" "1.42.6"
      "sha256-5FkF5dhEfWGt5XNRqT4kGhhSfjxdWKM02QqmgOMSaBM=";

  mypy-boto3-route53-recovery-cluster =
    buildMypyBoto3Package "route53-recovery-cluster" "1.42.3"
      "sha256-UmasOtzfGq3MAelpwB9Ddi7QdUzMHYoGvd4hmTNmVfo=";

  mypy-boto3-route53-recovery-control-config =
    buildMypyBoto3Package "route53-recovery-control-config" "1.42.3"
      "sha256-qEo5gf2kknkHmYgYnMDnEqnsffn47hVrkdnjwYOUI3A=";

  mypy-boto3-route53-recovery-readiness =
    buildMypyBoto3Package "route53-recovery-readiness" "1.42.3"
      "sha256-9vR13ok2puJXdMyFSXVwgL+OJ2vBXUicZiV2KepvBbE=";

  mypy-boto3-route53domains =
    buildMypyBoto3Package "route53domains" "1.42.3"
      "sha256-AasFHhNs7b904wj2hzm0Hhj0CHit16bl+f+0cl9Y/t4=";

  mypy-boto3-route53resolver =
    buildMypyBoto3Package "route53resolver" "1.42.10"
      "sha256-4zDAA7G0yZl+cm8l2aW/ATWy/Zv/1ogO1IYy7fmBKCk=";

  mypy-boto3-rum =
    buildMypyBoto3Package "rum" "1.42.3"
      "sha256-4/Q39UsUYaluauoaLm6BOej+Krl2VbO1xKKo1orRIkI=";

  mypy-boto3-s3 =
    buildMypyBoto3Package "s3" "1.42.94"
      "sha256-HZLXIs8AVzuBEemEk6s4bgwbWaFTC3/uSvd/LZocR30=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.42.94"
      "sha256-bGXhCT1/if/D2a4bKa+RuBVazjZ4w0BA7A8gYgbeKO0=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.42.3"
      "sha256-juVfwdjPDNPaT5tvyXpzDtomugqxeu++AERLkVtFIxw=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.42.97"
      "sha256-FGjRmINeQxxdn20Jn7SvjwYfpDZdfDys/VTC6fzGov0=";

  mypy-boto3-sagemaker-a2i-runtime =
    buildMypyBoto3Package "sagemaker-a2i-runtime" "1.42.3"
      "sha256-dmUsLcno/E2Sb/mcdVve8qb10gOq2wMBy9P0w+MmS1w=";

  mypy-boto3-sagemaker-edge =
    buildMypyBoto3Package "sagemaker-edge" "1.42.3"
      "sha256-k6ZCEvbci8RRwe1vlkO0t7PYqt2NpmePqqARujXhrOI=";

  mypy-boto3-sagemaker-featurestore-runtime =
    buildMypyBoto3Package "sagemaker-featurestore-runtime" "1.42.3"
      "sha256-68wT26P5cEJAl2nFgmV9NGy9q+hXa7+pSQtBX65Don0=";

  mypy-boto3-sagemaker-geospatial =
    buildMypyBoto3Package "sagemaker-geospatial" "1.42.3"
      "sha256-GENjDtRmX7c7uAOgbKn1vEkpXDJu7Z2Qilks8TVn9GY=";

  mypy-boto3-sagemaker-metrics =
    buildMypyBoto3Package "sagemaker-metrics" "1.42.3"
      "sha256-+SQRuoyCF3xgXvSbazaRk9dPQeOfGJZYu3vKSn4l44Y=";

  mypy-boto3-sagemaker-runtime =
    buildMypyBoto3Package "sagemaker-runtime" "1.42.54"
      "sha256-Y3kJS5tHq/aBkvWs3PJCuI0AcfYa8aa2hogo+CC9uPE=";

  mypy-boto3-savingsplans =
    buildMypyBoto3Package "savingsplans" "1.42.62"
      "sha256-ah5aNvlMpjEz/nec9LBb8eb/WVUT8hw12sQzTA/Wu0s=";

  mypy-boto3-scheduler =
    buildMypyBoto3Package "scheduler" "1.42.3"
      "sha256-nyVmH5XeePQ71QEVc6GZ3UYJ4l/6oI/CUVImT/thRr4=";

  mypy-boto3-schemas =
    buildMypyBoto3Package "schemas" "1.42.3"
      "sha256-iu65bUCX50x4VRLSWNXwvpE2gOjOhyJxmvhWtHYvrSI=";

  mypy-boto3-sdb =
    buildMypyBoto3Package "sdb" "1.42.3"
      "sha256-CwXzHFKnprY3TLQUMkGU9PC3rR/mjrKwUN9eJ30hPWk=";

  mypy-boto3-secretsmanager =
    buildMypyBoto3Package "secretsmanager" "1.42.8"
      "sha256-WrQvNc6TJ2XrsWhBRvR4qHzEuDvvlQ/Rqg4mi4jVnIE=";

  mypy-boto3-securityhub =
    buildMypyBoto3Package "securityhub" "1.42.89"
      "sha256-cXpUTYf1lt0Wtu39NzdaKjgJRyRsIOpJ+GJPvO7Iu/Y=";

  mypy-boto3-securitylake =
    buildMypyBoto3Package "securitylake" "1.42.3"
      "sha256-NoJ45saKUlWFpzUksZPrnUfj8yl1ivfXRoID38pqxGU=";

  mypy-boto3-serverlessrepo =
    buildMypyBoto3Package "serverlessrepo" "1.42.3"
      "sha256-JIwTLfrkWY98gY+eH15Sy7r9Kif+68pBqgmZoj2DTWQ=";

  mypy-boto3-service-quotas =
    buildMypyBoto3Package "service-quotas" "1.42.10"
      "sha256-aqQDN3jmfxcZ8PLBE9wsb4M2N7w3B+3ruKNcAngyKFE=";

  mypy-boto3-servicecatalog =
    buildMypyBoto3Package "servicecatalog" "1.42.3"
      "sha256-pCZjmXqOAWJVmiuL0q8nsCN6RZJDWYH9sM/a8NYe84A=";

  mypy-boto3-servicecatalog-appregistry =
    buildMypyBoto3Package "servicecatalog-appregistry" "1.42.3"
      "sha256-Duojb0uujD4zvfXBRiCSq33Gj/Fdf8t0VDfGKxhnGjw=";

  mypy-boto3-servicediscovery =
    buildMypyBoto3Package "servicediscovery" "1.42.3"
      "sha256-TNOD43uSjgeiYfwBJTQuflWDoQobhOw39+527t71tyA=";

  mypy-boto3-ses =
    buildMypyBoto3Package "ses" "1.42.3"
      "sha256-gGSjHXCQf4jHTYaJQWRRQfdpr82gGklxWeWBrLx5/Is=";

  mypy-boto3-sesv2 =
    buildMypyBoto3Package "sesv2" "1.42.63"
      "sha256-GlrB1mkbgd6cbnC1O2dKPdyUsKqWgMR7A5UCsXbInSc=";

  mypy-boto3-shield =
    buildMypyBoto3Package "shield" "1.42.3"
      "sha256-AXqV0TsOLNYBdDVFzigW99tfKCUvvrS7S/F8nT3xSOw=";

  mypy-boto3-signer =
    buildMypyBoto3Package "signer" "1.42.7"
      "sha256-fCXwGT1LLfoP3NowF1/8O/vQ6jHAY2/wikZ7ZkMgn1o=";

  mypy-boto3-simspaceweaver =
    buildMypyBoto3Package "simspaceweaver" "1.42.3"
      "sha256-g9Yh4KSIERm9Uo2F9hnDPF+6tU57mxt0Q9goLyBnMfE=";

  mypy-boto3-sms =
    buildMypyBoto3Package "sms" "1.40.0"
      "sha256-ZVrH3luEpHwORa+1LNdmgju3+JUy9/F6ghNzHZUicBc=";

  mypy-boto3-sms-voice =
    buildMypyBoto3Package "sms-voice" "1.38.0"
      "sha256-qWnTJxM1h3pmY2PnI8PjT7u4+xODrSQM41IK8QsJCfM=";

  mypy-boto3-snow-device-management =
    buildMypyBoto3Package "snow-device-management" "1.42.3"
      "sha256-wNuzufARcqJ8liqDq2uSLxf6OvHt6ILm4uwi2mZ22rM=";

  mypy-boto3-snowball =
    buildMypyBoto3Package "snowball" "1.42.93"
      "sha256-SUWzgGwyfU5afIs2m2LHdiRX0D1vYGdQUrOEHe498Z8=";

  mypy-boto3-sns =
    buildMypyBoto3Package "sns" "1.42.3"
      "sha256-Ht/oi/MOsZHcSZN45154ABzPDCnjcqxJqM/MhgBdin4=";

  mypy-boto3-sqs =
    buildMypyBoto3Package "sqs" "1.42.3"
      "sha256-aZmVuab2mpfG0+kSanbwZ1HjtAVkAXT+fCD+cdndyCo=";

  mypy-boto3-ssm =
    buildMypyBoto3Package "ssm" "1.42.54"
      "sha256-9LwZoIY1dXgItm75SltSw3KdqZhYd0WWJibmBgahviw=";

  mypy-boto3-ssm-contacts =
    buildMypyBoto3Package "ssm-contacts" "1.42.3"
      "sha256-94OFvLuYx8Y4eKtGXA2Vbl6Rxh2MV9IOHfbFB2tL3kM=";

  mypy-boto3-ssm-incidents =
    buildMypyBoto3Package "ssm-incidents" "1.42.3"
      "sha256-s3qgmNIltIoSjjA1r6t9cRmX78Nhizx+sSBn73XB7sI=";

  mypy-boto3-ssm-sap =
    buildMypyBoto3Package "ssm-sap" "1.42.13"
      "sha256-Act3QA/AfxQSawufOj0Onfs0N3s1ua2GTTz/EtluRR8=";

  mypy-boto3-sso =
    buildMypyBoto3Package "sso" "1.42.3"
      "sha256-eLm650XMxikqnBzOWD6aZo8dYVmVkl3Mk0+SqZcON8c=";

  mypy-boto3-sso-admin =
    buildMypyBoto3Package "sso-admin" "1.42.41"
      "sha256-AbfHjc5UxxCdT5w7WS2EYMmWZU2xGpIeIe3ZZzhidL0=";

  mypy-boto3-sso-oidc =
    buildMypyBoto3Package "sso-oidc" "1.42.67"
      "sha256-POfoZvj0owBR5hm8kaVqbc0jJEQemELE/PK5EUvAfvU=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.42.3"
      "sha256-vzj520LhROhseAff8SdVTe/hVIoQuiWCT2nMdFVPpbU=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.42.3"
      "sha256-92jALXRmjt/8Ji99jF3304T/xKW+gV1Ix3/N+fmodJc=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.42.91"
      "sha256-8i2gqRwZNEGSSqXiTFdKvnymyyExqQyut0JW+hSgaHg=";

  mypy-boto3-support =
    buildMypyBoto3Package "support" "1.42.3"
      "sha256-G99OogEGnAisLOIMdCdLJHfiFoZEWL+7UmySNOKyoTQ=";

  mypy-boto3-support-app =
    buildMypyBoto3Package "support-app" "1.42.3"
      "sha256-1MD4eTC9fVXlQoARoHll43GMf1rKLG2pvGzPGH0Q6vw=";

  mypy-boto3-swf =
    buildMypyBoto3Package "swf" "1.42.3"
      "sha256-OwWkvl0G76mX+rDyu5IMff+DsfD00k37y/TEFBp6Vf4=";

  mypy-boto3-synthetics =
    buildMypyBoto3Package "synthetics" "1.42.3"
      "sha256-IvQ168llb/sf6AeAmNueoe3U7ghNuJ8Kbw5gh8kFMq0=";

  mypy-boto3-textract =
    buildMypyBoto3Package "textract" "1.42.3"
      "sha256-j4vFnFjR5/kf6KeJtCXJFwqfEUOQ3Rz+++OJrLd3MR0=";

  mypy-boto3-timestream-query =
    buildMypyBoto3Package "timestream-query" "1.42.3"
      "sha256-iChDRilp+M6JnrE0q7sUIZ7I1XqX2wuU9yAo5B5vsOQ=";

  mypy-boto3-timestream-write =
    buildMypyBoto3Package "timestream-write" "1.42.3"
      "sha256-KDNxfSnrpiTc42Hf6agslUac3X0H8HMHEXSBYOeN5B8=";

  mypy-boto3-tnb =
    buildMypyBoto3Package "tnb" "1.42.3"
      "sha256-NCC+R+BEAT1bZ+J3zvC/FI7lZkHfR8OiCIQUjVefMxY=";

  mypy-boto3-transcribe =
    buildMypyBoto3Package "transcribe" "1.42.25"
      "sha256-RQkxMKk7svSYMoPac44m9X0YyEEQWCz/geSRD2qjlI8=";

  mypy-boto3-transfer =
    buildMypyBoto3Package "transfer" "1.42.96"
      "sha256-Y/3Va1N/wP9vYfdHeqovrz0UHZLB3JFHg8K4Y+Ewycs=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.42.3"
      "sha256-olIHhtYBAz8+avIUNnLoD2pdMq+TLrB8Mn+haKeUl/0=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.42.73"
      "sha256-TwSUJodBgjjNTth4HC8XQ4h20eXCVX+r6Dwl2D7K7n0=";

  mypy-boto3-voice-id =
    buildMypyBoto3Package "voice-id" "1.42.3"
      "sha256-ovnE8szKPWozcpBtzxDE8Cqz5zUuY7rIm7IbKMnzVfw=";

  mypy-boto3-vpc-lattice =
    buildMypyBoto3Package "vpc-lattice" "1.42.3"
      "sha256-FyymePjaNzAl07HDHPW6M71N1eCkED5L75hhGPoGogA=";

  mypy-boto3-waf =
    buildMypyBoto3Package "waf" "1.42.3"
      "sha256-NIRqd/ZG9qZhb8GJUgk8KZUsejQwCPriCMND7EJLY5M=";

  mypy-boto3-waf-regional =
    buildMypyBoto3Package "waf-regional" "1.42.3"
      "sha256-FEl4TtWX042gUuznqlc25HoIbMcCKhE85uuJPh8Kt+E=";

  mypy-boto3-wafv2 =
    buildMypyBoto3Package "wafv2" "1.42.57"
      "sha256-fCmLmGyNNPDQLK7eVKPPcimWQbodt3tgs/7F4MZW39Y=";

  mypy-boto3-wellarchitected =
    buildMypyBoto3Package "wellarchitected" "1.42.3"
      "sha256-+grWgv9THkvVIf3IPxN4bai4cpMHsv5NdJQnEKB5Ivo=";

  mypy-boto3-wisdom =
    buildMypyBoto3Package "wisdom" "1.42.3"
      "sha256-r2iOH2Uc9dPqglIaSwNVv3yemOWVI3KY+M4bLaOFLio=";

  mypy-boto3-workdocs =
    buildMypyBoto3Package "workdocs" "1.42.3"
      "sha256-bIMm0QOfErvZMFXiFCHMMi+xfvcsFI25geMXzCHEBkU=";

  mypy-boto3-worklink =
    buildMypyBoto3Package "worklink" "1.35.0"
      "sha256-AgK4Xg1dloJmA+h4+mcBQQVTvYKjLCk5tPDbl/ItCVQ=";

  mypy-boto3-workmail =
    buildMypyBoto3Package "workmail" "1.42.3"
      "sha256-wTEMdjr8c14xH1KDPLnSnD3eg/TkOt5eF2ooGxzcIoc=";

  mypy-boto3-workmailmessageflow =
    buildMypyBoto3Package "workmailmessageflow" "1.42.3"
      "sha256-bxh+mhwsHHwt/cx/njegTa/QGHu+xa7YPg4SRos1deM=";

  mypy-boto3-workspaces =
    buildMypyBoto3Package "workspaces" "1.42.97"
      "sha256-WLheY3TM39Li6b6cvzsEgNTMplDikmoh5zuQ0aRLNAk=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.42.51"
      "sha256-1LoVLQsBJnWfTwVi9F4kJjZhFWq71/uZPDDV7az9xGI=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.42.3"
      "sha256-gJLEGWfu0tD+4JaiKwgrsQfP4rtGeo3X+9w5JZPxlpw=";
}
