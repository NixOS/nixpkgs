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
    buildMypyBoto3Package "accessanalyzer" "1.42.3"
      "sha256-6eYpAzfuDqzsW0FYFpdZ4TpdPeS0D+s8Y7LX8B1QwOw=";

  mypy-boto3-account =
    buildMypyBoto3Package "account" "1.42.6"
      "sha256-FtWO7IGhuWHuDyZTxFWdP8YC5Lz7CErmvKYQ+cYnxEs=";

  mypy-boto3-acm =
    buildMypyBoto3Package "acm" "1.42.3"
      "sha256-5g2+5aDKHUJUr1LhGpsv1MovPFLuKvzNGlqFAn7m+xM=";

  mypy-boto3-acm-pca =
    buildMypyBoto3Package "acm-pca" "1.42.3"
      "sha256-0lg6uZvh8R3Vk1WpUUliceEbU8oHniIkfpYkX1q8VnM=";

  mypy-boto3-amp =
    buildMypyBoto3Package "amp" "1.42.3"
      "sha256-hT/YK9234i1l9viz0pGJm7ab5spLxbfGmlzeKc/8naA=";

  mypy-boto3-amplify =
    buildMypyBoto3Package "amplify" "1.42.3"
      "sha256-T3jbr0pptSc8vfUoSU9qQSelKfALNmm9W9rD7KppajE=";

  mypy-boto3-amplifybackend =
    buildMypyBoto3Package "amplifybackend" "1.42.3"
      "sha256-LyQTUXGSdt7IJrOOOEcJg66VcI9xtX3/kG2B+r+B9og=";

  mypy-boto3-amplifyuibuilder =
    buildMypyBoto3Package "amplifyuibuilder" "1.42.3"
      "sha256-Q8nkt2PJnip62r2lbCZcB9qGE6sSg28ZAycLI8gIQ7s=";

  mypy-boto3-apigateway =
    buildMypyBoto3Package "apigateway" "1.42.3"
      "sha256-JVGKx+VCoE4EvUrxsmFsdXwu6gaprva+q1xrsSl5EDA=";

  mypy-boto3-apigatewaymanagementapi =
    buildMypyBoto3Package "apigatewaymanagementapi" "1.42.3"
      "sha256-Krejmp4mDW+6W1eGgpk8qeujMKXepkZZF3FS6PuG1tI=";

  mypy-boto3-apigatewayv2 =
    buildMypyBoto3Package "apigatewayv2" "1.42.3"
      "sha256-lnm33RjFDpXub+eittBLdXbhKiq/4lKK1ste+hIEjIg=";

  mypy-boto3-appconfig =
    buildMypyBoto3Package "appconfig" "1.42.3"
      "sha256-YG03dlJZyFSjV06sw/5co5VrXEVrEv+AyOHLIL2rkRk=";

  mypy-boto3-appconfigdata =
    buildMypyBoto3Package "appconfigdata" "1.42.3"
      "sha256-WV426fR3IFkW4fEdKMbDNdYGog5VvLeTpDpLSKSysy0=";

  mypy-boto3-appfabric =
    buildMypyBoto3Package "appfabric" "1.42.3"
      "sha256-1yz5ybS89QjB90u8jBtGfcO3yr8ps0YgY8hR8f4ULuE=";

  mypy-boto3-appflow =
    buildMypyBoto3Package "appflow" "1.42.3"
      "sha256-JUvz8VRO/t7KlrvFYWb53Qj8uXDOwHFtT16QCxO/ubw=";

  mypy-boto3-appintegrations =
    buildMypyBoto3Package "appintegrations" "1.42.3"
      "sha256-VCD5PLHXJvusiSh9uIN9mrAHA1jwklF4SU7h6AWxzG0=";

  mypy-boto3-application-autoscaling =
    buildMypyBoto3Package "application-autoscaling" "1.42.3"
      "sha256-lO+lh3quoxg68y9p1wx8plhWFFtVBf6BNIKZhYMQ8OQ=";

  mypy-boto3-application-insights =
    buildMypyBoto3Package "application-insights" "1.42.3"
      "sha256-8AwPxJHXtgmSPfyfuoLeno49sLJ3lJhBWB+vK56iTUI=";

  mypy-boto3-applicationcostprofiler =
    buildMypyBoto3Package "applicationcostprofiler" "1.42.3"
      "sha256-6fh0DnPk3yhleWCLnUJ/is5nRXrXZXEzpi8oO4q1zK0=";

  mypy-boto3-appmesh =
    buildMypyBoto3Package "appmesh" "1.42.3"
      "sha256-97tJFt934dOeY79zPZmYdSIorRSgVT0N1PT0DvcDbjA=";

  mypy-boto3-apprunner =
    buildMypyBoto3Package "apprunner" "1.42.3"
      "sha256-Mvf3bBhrRRR+hoAsBPq7p9COJqVxV9LL+GrnikrHX2g=";

  mypy-boto3-appstream =
    buildMypyBoto3Package "appstream" "1.42.54"
      "sha256-NrR4wQslCosBCvmAkGe7qJ3WNu428hD3+SZUk1Ga870=";

  mypy-boto3-appsync =
    buildMypyBoto3Package "appsync" "1.42.6"
      "sha256-+juUSMxU7Ohy6l/CHdq5vPmlRM/f0PcXl35LsT7k03s=";

  mypy-boto3-arc-zonal-shift =
    buildMypyBoto3Package "arc-zonal-shift" "1.42.3"
      "sha256-9GHZy/GvevYqzWoY9ubb+/8P33SMvNUurg9WsUq82ls=";

  mypy-boto3-athena =
    buildMypyBoto3Package "athena" "1.42.43"
      "sha256-1IGcRscPDjjEn/7129vTl8jWakc/jBsRawOhxFq/66c=";

  mypy-boto3-auditmanager =
    buildMypyBoto3Package "auditmanager" "1.42.3"
      "sha256-jW+LgaUpdeCSJLnpNE13DSio9nFmp0icoLEMwxX44KU=";

  mypy-boto3-autoscaling =
    buildMypyBoto3Package "autoscaling" "1.42.33"
      "sha256-F1+6Sd7kaCrZlulXzrFmF3RFUPEmRNvKeB1xQeSGgq4=";

  mypy-boto3-autoscaling-plans =
    buildMypyBoto3Package "autoscaling-plans" "1.42.3"
      "sha256-BJ5MKA8jpafHN014Y+pLo1IKcVq1PAfufGlCFwEGSKk=";

  mypy-boto3-backup =
    buildMypyBoto3Package "backup" "1.42.3"
      "sha256-ESsxNpqqY56rqbweQLpcLDA25i6+A59hiOB9AUk+W8k=";

  mypy-boto3-backup-gateway =
    buildMypyBoto3Package "backup-gateway" "1.42.58"
      "sha256-G3kwLm2IEgXNFrs8V2uCj0su2S3P72FzmWSOEYjlV4c=";

  mypy-boto3-batch =
    buildMypyBoto3Package "batch" "1.42.59"
      "sha256-RYL6s/uF5iFEIEFewaq2gXX7YeKgC1EWomCRyerJZS4=";

  mypy-boto3-billingconductor =
    buildMypyBoto3Package "billingconductor" "1.42.7"
      "sha256-ZQsHPgnPepj1HbBd37u76Fd1td4M7B5o6kId8FPP5yQ=";

  mypy-boto3-braket =
    buildMypyBoto3Package "braket" "1.42.3"
      "sha256-p8bdld0zrW6NzBndSczyHclvkhKb4VW8npiAKz+8Ge4=";

  mypy-boto3-budgets =
    buildMypyBoto3Package "budgets" "1.42.33"
      "sha256-opWm1iTVk4erudBdsTJ/AzXF3gDDwOGHiZEwV7CP8V4=";

  mypy-boto3-ce =
    buildMypyBoto3Package "ce" "1.42.28"
      "sha256-WOV41Me/uQKGrDotJutJyUuH8XIeMFrnkE204NFFFGk=";

  mypy-boto3-chime =
    buildMypyBoto3Package "chime" "1.42.3"
      "sha256-7p41zcpRdNp1A09ipeKMnsLzws+z/Zsq6AMk6aePvoA=";

  mypy-boto3-chime-sdk-identity =
    buildMypyBoto3Package "chime-sdk-identity" "1.42.3"
      "sha256-ISo7In03FFfx4u7qzLR9u+9XuzmLW7VLYYs1WmMT5BI=";

  mypy-boto3-chime-sdk-media-pipelines =
    buildMypyBoto3Package "chime-sdk-media-pipelines" "1.42.3"
      "sha256-7Azzr1VUhy9D+75EwPDUs0rAsGIGetAvWAyLRywc+6M=";

  mypy-boto3-chime-sdk-meetings =
    buildMypyBoto3Package "chime-sdk-meetings" "1.42.3"
      "sha256-1mD2BSPxGoRcre0iHaUWkn7E8GypVbaINF8BiT2nb64=";

  mypy-boto3-chime-sdk-messaging =
    buildMypyBoto3Package "chime-sdk-messaging" "1.42.3"
      "sha256-VhdO0Sa0eJuD/JWk+ALrG+XviDbb81PW9pYOaCPWzF0=";

  mypy-boto3-chime-sdk-voice =
    buildMypyBoto3Package "chime-sdk-voice" "1.42.3"
      "sha256-Yj+PL5SHeMuiC3kougQa6zahznlD32+1NQWqoD8xdEg=";

  mypy-boto3-cleanrooms =
    buildMypyBoto3Package "cleanrooms" "1.42.52"
      "sha256-YSYDtUF4SNy6b1PuEvBFrRLjCzOnGd0UbN8Xe7GSDh8=";

  mypy-boto3-cloud9 =
    buildMypyBoto3Package "cloud9" "1.42.3"
      "sha256-KZVvBn+NTk8gPgzPxb1vbC8osYsmNBR106k05Y2h6R4=";

  mypy-boto3-cloudcontrol =
    buildMypyBoto3Package "cloudcontrol" "1.42.3"
      "sha256-JnSrsxpu+qcRkywLOexkrtfFjAkK9uZ/R4+lo6pIleo=";

  mypy-boto3-clouddirectory =
    buildMypyBoto3Package "clouddirectory" "1.42.3"
      "sha256-3ODxia6FDYDvvzITeP7asJhuVV4M9mMI8iw0JlaSuIU=";

  mypy-boto3-cloudformation =
    buildMypyBoto3Package "cloudformation" "1.42.3"
      "sha256-O9OEm8iaNx1MNoaRU1syAkS6AFec3dY7tYtz8o1w5RA=";

  mypy-boto3-cloudfront =
    buildMypyBoto3Package "cloudfront" "1.42.40"
      "sha256-5xhiNDkHCtL2AmL2asOOZbwbxL5etj5anUOnKja5+Ic=";

  mypy-boto3-cloudhsm =
    buildMypyBoto3Package "cloudhsm" "1.42.3"
      "sha256-Bxet+xXHr3VUxQEaNhJzvZAFkT0yk4O9CaJks91gtkY=";

  mypy-boto3-cloudhsmv2 =
    buildMypyBoto3Package "cloudhsmv2" "1.42.3"
      "sha256-i1q4pVmKPj7e6amzdWWz+ZuXR14dCENIhG07mU5xsEE=";

  mypy-boto3-cloudsearch =
    buildMypyBoto3Package "cloudsearch" "1.42.3"
      "sha256-vinIbxGEPhGko4DnHDtNKBGm5EwYu7SpknV/QVdQr3Q=";

  mypy-boto3-cloudsearchdomain =
    buildMypyBoto3Package "cloudsearchdomain" "1.42.3"
      "sha256-t3cUQtOO2ZDZsBdcA9XinyF5tZiZVC5fatcbwQlzXAA=";

  mypy-boto3-cloudtrail =
    buildMypyBoto3Package "cloudtrail" "1.42.3"
      "sha256-cJHd1HRP4r0xrlegID0GXjIKNqEtS3hUB2J6XmhIL8U=";

  mypy-boto3-cloudtrail-data =
    buildMypyBoto3Package "cloudtrail-data" "1.42.3"
      "sha256-S2NgrjralqxjjGo39TwaUSStqspnhI/E2/BLXUGP0Hc=";

  mypy-boto3-cloudwatch =
    buildMypyBoto3Package "cloudwatch" "1.42.56"
      "sha256-Z5GriV29LChx+MDWhq5a2zlBjb1GUVmW4sgKWWZNDc8=";

  mypy-boto3-codeartifact =
    buildMypyBoto3Package "codeartifact" "1.42.3"
      "sha256-YkeABuPHoW5nQG1B01thEv8T5M8KB1cxstw5eCiet1A=";

  mypy-boto3-codebuild =
    buildMypyBoto3Package "codebuild" "1.42.3"
      "sha256-yacISwHjButV2KY3cYD2QyvnGaNFt62lhjpsLh85OPc=";

  mypy-boto3-codecatalyst =
    buildMypyBoto3Package "codecatalyst" "1.42.3"
      "sha256-XX3A98JxTsrinKTDxj949XYUliqoTKiu+WUY7jK3q4o=";

  mypy-boto3-codecommit =
    buildMypyBoto3Package "codecommit" "1.42.3"
      "sha256-8vPx4zud7dPV+FXln6rR6RaYlY+wiGhrf6KPsJoBxsc=";

  mypy-boto3-codedeploy =
    buildMypyBoto3Package "codedeploy" "1.42.3"
      "sha256-nUPEMOLK9Lb61aYZ8bgjBCEotVXL2ku2BPdVXwjNPXM=";

  mypy-boto3-codeguru-reviewer =
    buildMypyBoto3Package "codeguru-reviewer" "1.42.3"
      "sha256-qUk0c9axiud0GSWBOwm0W5cNJOGRLkSi4Sz+GdmF/c4=";

  mypy-boto3-codeguru-security =
    buildMypyBoto3Package "codeguru-security" "1.42.3"
      "sha256-nvbGqJPJ67ipJSPtVWF10vbZSx5PtXE5HTKPH8runvc=";

  mypy-boto3-codeguruprofiler =
    buildMypyBoto3Package "codeguruprofiler" "1.42.3"
      "sha256-rDZJQ/nKSLdwz48jmVGXWf61sq7hQzKFt8b6zitZiRE=";

  mypy-boto3-codepipeline =
    buildMypyBoto3Package "codepipeline" "1.42.3"
      "sha256-lZRCPyZPbUXrCLvZicdB4Yi8RfK1NS5Cjt8uuxz12rY=";

  mypy-boto3-codestar =
    buildMypyBoto3Package "codestar" "1.35.0"
      "sha256-B9Aq+hh9BOzCIYMkS21IZYb3tNCnKnV2OpSIo48aeJM=";

  mypy-boto3-codestar-connections =
    buildMypyBoto3Package "codestar-connections" "1.42.3"
      "sha256-N2s7ir1VezlVgTJfL1Q9wmT5VyhCyxvy9hPMM9pgavg=";

  mypy-boto3-codestar-notifications =
    buildMypyBoto3Package "codestar-notifications" "1.42.3"
      "sha256-/Do27W8Ye71TMnvS9cihH+NgyuhbYjnQZlRy5IhZPyE=";

  mypy-boto3-cognito-identity =
    buildMypyBoto3Package "cognito-identity" "1.42.3"
      "sha256-N9PEmvqI7Yc7AAuDdOj1iePSq7hJTgOmS+4z7GzYd98=";

  mypy-boto3-cognito-idp =
    buildMypyBoto3Package "cognito-idp" "1.42.59"
      "sha256-TE+BT1wJvhWsNq1nnyiX6QbT0oHVCvMa/YzChpI3gls=";

  mypy-boto3-cognito-sync =
    buildMypyBoto3Package "cognito-sync" "1.42.3"
      "sha256-hRjavmc5Uz2JInrXnUrFlby+XPaP2hIShhPbHreE5/4=";

  mypy-boto3-comprehend =
    buildMypyBoto3Package "comprehend" "1.42.3"
      "sha256-b+dX5aCg7czhnGTapZ1DdIYyNcr8bb1SGEmw96oe2jI=";

  mypy-boto3-comprehendmedical =
    buildMypyBoto3Package "comprehendmedical" "1.42.3"
      "sha256-F4zRXA2p9DfQnXItfz4VYlB1ueDwV5MORUCDHxOcr2w=";

  mypy-boto3-compute-optimizer =
    buildMypyBoto3Package "compute-optimizer" "1.42.3"
      "sha256-M8vUOtM7Q5gnwi9ZPGu6n+I4Twl02Su4eRGqq2+Ow1o=";

  mypy-boto3-config =
    buildMypyBoto3Package "config" "1.42.32"
      "sha256-HQUL0R1NWP6DXQ26iS9k6lIAVdwK899fwLGH4/Z4U8Q=";

  mypy-boto3-connect =
    buildMypyBoto3Package "connect" "1.42.59"
      "sha256-Emsl+UKfvHGf0KKvTdTIZ5gw+NJMEom5zz+AfcJZWD8=";

  mypy-boto3-connect-contact-lens =
    buildMypyBoto3Package "connect-contact-lens" "1.42.3"
      "sha256-DskvuhNLcAzgDj7jBahKQmhYI6N8iWvGU5Q+1x2IQDI=";

  mypy-boto3-connectcampaigns =
    buildMypyBoto3Package "connectcampaigns" "1.42.3"
      "sha256-omWYUcr7Aj6r1F1kKAmM32fn9577UeUgqesnIiBIpPQ=";

  mypy-boto3-connectcases =
    buildMypyBoto3Package "connectcases" "1.42.55"
      "sha256-wB3bSavhTTCIvF/5myLyIHItqPvNvudCzoB2tt8g1iM=";

  mypy-boto3-connectparticipant =
    buildMypyBoto3Package "connectparticipant" "1.42.3"
      "sha256-vDq9icNnmldtEKNlE3yia15L2LNbQiNctYRM2qS2GaE=";

  mypy-boto3-controltower =
    buildMypyBoto3Package "controltower" "1.42.3"
      "sha256-EJatOlrK5f9nET1S2rq8o3ZZBcYZzKerscG6aiVzW3E=";

  mypy-boto3-cur =
    buildMypyBoto3Package "cur" "1.42.3"
      "sha256-SAgpP1O6oGP8QIp6qoG4bu/axKZyVWgbdt8ZmZkrezY=";

  mypy-boto3-customer-profiles =
    buildMypyBoto3Package "customer-profiles" "1.42.59"
      "sha256-NHIaeJHrZ8mLDNY98rGrWbBILWtol3yuRDkKT9nlvEE=";

  mypy-boto3-databrew =
    buildMypyBoto3Package "databrew" "1.42.3"
      "sha256-PYO9ZRqOwz+typG60P14BoeDTSztuoNna35i3QWQE5w=";

  mypy-boto3-dataexchange =
    buildMypyBoto3Package "dataexchange" "1.42.3"
      "sha256-mSIcKVS51A7sgKo1KU1r5zxtco9Y1umGrYbeCzaugqY=";

  mypy-boto3-datapipeline =
    buildMypyBoto3Package "datapipeline" "1.42.3"
      "sha256-MExczpvtitz7h8p+wS8mKCToOQiiQwcOl3jzbKHbVzI=";

  mypy-boto3-datasync =
    buildMypyBoto3Package "datasync" "1.42.9"
      "sha256-/OU5QUhkJ5WtoNfmgWye49vjbQlKE3vDJMlONyrH4WA=";

  mypy-boto3-dax =
    buildMypyBoto3Package "dax" "1.42.3"
      "sha256-ckBSxGRvIg5zvbjpXiWK04FLfbf77kWkxlVGhYJBGps=";

  mypy-boto3-detective =
    buildMypyBoto3Package "detective" "1.42.3"
      "sha256-Yi12y0nw4kLlMI8E2syBMqrOW5ruImUn2mMQAZdKFXg=";

  mypy-boto3-devicefarm =
    buildMypyBoto3Package "devicefarm" "1.42.3"
      "sha256-cknaGndSi5ak+3gRl4Acp3yHg3kD2g4bIGw7WxB3yfA=";

  mypy-boto3-devops-guru =
    buildMypyBoto3Package "devops-guru" "1.42.3"
      "sha256-jJriPVQX4T4oUT2cnmZigxqjTXNx+esnU2xYvkp0C6E=";

  mypy-boto3-directconnect =
    buildMypyBoto3Package "directconnect" "1.42.3"
      "sha256-Jn3ozTTbTDJkDm4mHNO/PS5xGnvk2tuNmaac7iGYCl8=";

  mypy-boto3-discovery =
    buildMypyBoto3Package "discovery" "1.42.3"
      "sha256-rZxsnERZZWod9U+7IyPVFYSncmbpNwtzoGQopSkb9sk=";

  mypy-boto3-dlm =
    buildMypyBoto3Package "dlm" "1.42.3"
      "sha256-oqmjFYk0Wfo+PF2ho1+noYSXlpivcwLCoLL66d052Q0=";

  mypy-boto3-dms =
    buildMypyBoto3Package "dms" "1.42.3"
      "sha256-i4MYwLQOhaynuGxcYB7w9dLGmbPqiQMpR+Hsqu0J4Eo=";

  mypy-boto3-docdb =
    buildMypyBoto3Package "docdb" "1.42.3"
      "sha256-ANTxQ58GFmS8ZVO4JQ94T2DbnpSmP3IneM0gEjXcfxw=";

  mypy-boto3-docdb-elastic =
    buildMypyBoto3Package "docdb-elastic" "1.42.3"
      "sha256-lELlqGCIpJDadB4McePclQ56IyVBo7s9B05mBI3vWdY=";

  mypy-boto3-drs =
    buildMypyBoto3Package "drs" "1.42.3"
      "sha256-31X59K6RtNoN/iIqZMkpoH1z55k69wteY/Mw2va4txI=";

  mypy-boto3-ds =
    buildMypyBoto3Package "ds" "1.42.3"
      "sha256-VLjmuBf9xHv0qwv2F3l/14KptFqXVE0OmwPF/WC06NI=";

  mypy-boto3-dynamodb =
    buildMypyBoto3Package "dynamodb" "1.42.55"
      "sha256-pEX0Oba8RTL9WSy39EREyPyPOXJxwNkIfnEvcfGW0vk=";

  mypy-boto3-dynamodbstreams =
    buildMypyBoto3Package "dynamodbstreams" "1.42.3"
      "sha256-Sf//Fv7Dhwlm/XYEdpF1+tHmUM+jy4tt5IA/maHh7zo=";

  mypy-boto3-ebs =
    buildMypyBoto3Package "ebs" "1.42.3"
      "sha256-92qhSUqTiLgbtvCdi/Mmgve18mcYR00ABL+bNy7/OnY=";

  mypy-boto3-ec2 =
    buildMypyBoto3Package "ec2" "1.42.58"
      "sha256-6UyKkBJa2ZnDaWK7u3KFrDX5hntWPlR7+L6LqZbmA7I=";

  mypy-boto3-ec2-instance-connect =
    buildMypyBoto3Package "ec2-instance-connect" "1.42.3"
      "sha256-qe5aitxIPiQA2Et/+MtGVsnmWvk45Rg04/U/kR+tmK0=";

  mypy-boto3-ecr =
    buildMypyBoto3Package "ecr" "1.42.57"
      "sha256-HWo7KIcJDl8Ioos1tDkaNNF1dfUY9Szbh54idTI6QTc=";

  mypy-boto3-ecr-public =
    buildMypyBoto3Package "ecr-public" "1.42.3"
      "sha256-syjw4M02YXRXsJpM3e7OikE3sSTl/hIIJ3857PP2BII=";

  mypy-boto3-ecs =
    buildMypyBoto3Package "ecs" "1.42.58"
      "sha256-dgAvcfFtb7TSr7aZofmV2SRNMWCBViZ5XcI5z2f8wmQ=";

  mypy-boto3-efs =
    buildMypyBoto3Package "efs" "1.42.3"
      "sha256-lNlav7BQkVjbYE9cdnvcdNki9IDo6tTlerD+lt69Rio=";

  mypy-boto3-eks =
    buildMypyBoto3Package "eks" "1.42.47"
      "sha256-40eBd8o+6R4kX2N8MR4NkoqtJ2lKAf/AghJSmfOTlKQ=";

  mypy-boto3-elastic-inference =
    buildMypyBoto3Package "elastic-inference" "1.36.0"
      "sha256-duU3LIeW3FNiplVmduZsNXBoDK7vbO6ecrBt1Y7C9rU=";

  mypy-boto3-elasticache =
    buildMypyBoto3Package "elasticache" "1.42.3"
      "sha256-4+ujCgzi4N92QEhsBbE8RSsKA1JAu4oJtlAlQ4uwXcU=";

  mypy-boto3-elasticbeanstalk =
    buildMypyBoto3Package "elasticbeanstalk" "1.42.3"
      "sha256-bdkMl7lZNe9af/V77qmSRP9vUFq8emG/i6lfb5c/bkk=";

  mypy-boto3-elastictranscoder =
    buildMypyBoto3Package "elastictranscoder" "1.42.3"
      "sha256-6fH7Mf2p9tYmendYBCHXKo+6NKkRP2j2ofLTrkxlrtU=";

  mypy-boto3-elb =
    buildMypyBoto3Package "elb" "1.42.3"
      "sha256-T8SWdNXQ+4IIPC2V9eKut2I9xi3ZhhXMbUZC8eBPW+o=";

  mypy-boto3-elbv2 =
    buildMypyBoto3Package "elbv2" "1.42.3"
      "sha256-ha8UiyvXgKk/G98JZYIfJh3v2EKWZwgxNir6BL0+RjU=";

  mypy-boto3-emr =
    buildMypyBoto3Package "emr" "1.42.3"
      "sha256-oh5SV2hqG7KcCgBpBeokWeYkBqYprKirv3lZxD2sCnA=";

  mypy-boto3-emr-containers =
    buildMypyBoto3Package "emr-containers" "1.42.3"
      "sha256-aSceDS6MkuNWdpvaZoeYGFeE8tApcoHus7FIlIlsX3M=";

  mypy-boto3-emr-serverless =
    buildMypyBoto3Package "emr-serverless" "1.42.23"
      "sha256-/6DQxeWrGSYhODipYuEaYnEbctT2LbNonuiOmd5Oo1Q=";

  mypy-boto3-entityresolution =
    buildMypyBoto3Package "entityresolution" "1.42.10"
      "sha256-DyAxO4HPA98ON9Q2Sp5HF1lQNp8yecGiEaV12m0E7zM=";

  mypy-boto3-es =
    buildMypyBoto3Package "es" "1.42.56"
      "sha256-52bnvdPDRbC/di9xSwDaoOqyNQIPXjqooUXVbypevaw=";

  mypy-boto3-events =
    buildMypyBoto3Package "events" "1.42.3"
      "sha256-zoJFU3RC1bgWvK/rTsAKRoWDbl1+VehjlGM9s18h7Fg=";

  mypy-boto3-evidently =
    buildMypyBoto3Package "evidently" "1.42.35"
      "sha256-kdSGsikyLazIdSKidTt6bk5i+syJgx/GE0y+KRpC1rw=";

  mypy-boto3-finspace =
    buildMypyBoto3Package "finspace" "1.42.3"
      "sha256-gwJY/iL22IIxcjIYtcURZSyn/7XeHEubw1rAgHFydj4=";

  mypy-boto3-finspace-data =
    buildMypyBoto3Package "finspace-data" "1.42.3"
      "sha256-OcVF/cSLsJ3zcv7iDF4z/z5p6qJTxrj0kwg6x1WpY5g=";

  mypy-boto3-firehose =
    buildMypyBoto3Package "firehose" "1.42.3"
      "sha256-OBj2x8ELpXJvwfkGf6LeOnBXc0WzLbkKsZ4zlnoI/fM=";

  mypy-boto3-fis =
    buildMypyBoto3Package "fis" "1.42.3"
      "sha256-CT7k07oPtWrCFNxA6Ga3I2Ej6clheMAdMDd//m3bgm0=";

  mypy-boto3-fms =
    buildMypyBoto3Package "fms" "1.42.3"
      "sha256-0h6KDGLtMUvl9VN+TIElcnxf+T85MPPwWhYKlIZ90uY=";

  mypy-boto3-forecast =
    buildMypyBoto3Package "forecast" "1.42.3"
      "sha256-vtRPtRfGg/Ab72ZDu5mU+IOkMWm9q1KExgHPoSeqYT8=";

  mypy-boto3-forecastquery =
    buildMypyBoto3Package "forecastquery" "1.42.3"
      "sha256-PMF12libsd9i/8gEjR35zGklqq7dKPoQlRmtPUytfVw=";

  mypy-boto3-frauddetector =
    buildMypyBoto3Package "frauddetector" "1.42.3"
      "sha256-okrKcMKNM5rJPzPx/kFnarcDBYoQh/IdJHZy3cK1m8c=";

  mypy-boto3-fsx =
    buildMypyBoto3Package "fsx" "1.42.3"
      "sha256-NqNGcL3HfJgx2ScPLKMNNwpVS3bO4Cu7JpYlenSJwJg=";

  mypy-boto3-gamelift =
    buildMypyBoto3Package "gamelift" "1.42.38"
      "sha256-z9RuMA2e/L1mGm59JhrIM+tDCQqQ7pRm2L5luhQSdoM=";

  mypy-boto3-glacier =
    buildMypyBoto3Package "glacier" "1.42.30"
      "sha256-TtiFsS2IIBgVxTwAWwU5M/0pBfXs1zxnnyjMuMhjWDY=";

  mypy-boto3-globalaccelerator =
    buildMypyBoto3Package "globalaccelerator" "1.42.3"
      "sha256-N0kQ7Fc44SFKXhl4V+oAclPNlWhluOs53NDokiXcSNM=";

  mypy-boto3-glue =
    buildMypyBoto3Package "glue" "1.42.43"
      "sha256-PBFrSU7QbOuaU5kWjYe6eA8k9BHdAZUuD3jMYLlFwF0=";
  mypy-boto3-grafana =
    buildMypyBoto3Package "grafana" "1.42.51"
      "sha256-QHAuRJrioMD7ASgV1Wobm81Gb+Z87c78yBs9X1+Kz+E=";

  mypy-boto3-greengrass =
    buildMypyBoto3Package "greengrass" "1.42.3"
      "sha256-8D2hxBxdFbrrXSHzvOUBoNkedTErIQG4mlcMx3r9yx4=";

  mypy-boto3-greengrassv2 =
    buildMypyBoto3Package "greengrassv2" "1.42.3"
      "sha256-w3vOm8K/2rToF1CFWtAobCzswkv2d/gm1bzy6XiOFVA=";

  mypy-boto3-groundstation =
    buildMypyBoto3Package "groundstation" "1.42.35"
      "sha256-UIxD9R+oQjVmR90OfD8Dp7GW3E73zny6LFTkxrSdmNU=";

  mypy-boto3-guardduty =
    buildMypyBoto3Package "guardduty" "1.42.33"
      "sha256-Xo4t/M+9Kly33WHxtXSgww0cbNyF59k4LBeyyFSbSMw=";

  mypy-boto3-health =
    buildMypyBoto3Package "health" "1.42.59"
      "sha256-ryg+TwVNMUGrKcvt565Y4BTylGnucbPVUsi/modP8mM=";

  mypy-boto3-healthlake =
    buildMypyBoto3Package "healthlake" "1.42.3"
      "sha256-dHLvIxMXNFxa5ImKkifyeMfFciLc3kzWD9776mmD5Vs=";

  mypy-boto3-iam =
    buildMypyBoto3Package "iam" "1.42.4"
      "sha256-QbF9VfRNMcpe8DiVeVBeZfbnn64EI7mP8lgeg/YoS8U=";

  mypy-boto3-identitystore =
    buildMypyBoto3Package "identitystore" "1.42.20"
      "sha256-rb8qotqFW+ZcesRS0TUl+NMsrOS7CTQosZ633jSE38k=";

  mypy-boto3-imagebuilder =
    buildMypyBoto3Package "imagebuilder" "1.42.45"
      "sha256-q8toJ7n/MSEt+w/n21rBEXHV7JAMJEno32RBmznPcKY=";

  mypy-boto3-importexport =
    buildMypyBoto3Package "importexport" "1.42.3"
      "sha256-Wu7msQDFRWieeKOSI4IqCovlny14zFPr/5UKvGEw9GU=";

  mypy-boto3-inspector =
    buildMypyBoto3Package "inspector" "1.42.3"
      "sha256-9I+RMsF8b8PK2OsmtgX8v6C6gvZ3h8zB9fQQF5CWh2o=";

  mypy-boto3-inspector2 =
    buildMypyBoto3Package "inspector2" "1.42.49"
      "sha256-iCLS3XGlO6FBe9ADkRKGQxPEuOfd2sVRkLiHhMrGZ3M=";

  mypy-boto3-internetmonitor =
    buildMypyBoto3Package "internetmonitor" "1.42.3"
      "sha256-rXXlHFkPI9DeMO2j+a0kLrieNt73t8//2UnUM2JskfI=";

  mypy-boto3-iot =
    buildMypyBoto3Package "iot" "1.42.14"
      "sha256-MMdIYRtWfA+JZ9F7s3/RbswInpLbf6v4mdecmtAJahI=";

  mypy-boto3-iot-data =
    buildMypyBoto3Package "iot-data" "1.42.3"
      "sha256-Giui5uqyTCAjCfpA5n/z+KwRNyqeMbd6fuxo+9Df8Ao=";

  mypy-boto3-iot-jobs-data =
    buildMypyBoto3Package "iot-jobs-data" "1.42.3"
      "sha256-rm1KJfUHizaTEOylpdQP5XzF3JbwBaBh2IfJWW0b5bs=";

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
    buildMypyBoto3Package "iotdeviceadvisor" "1.42.3"
      "sha256-WhX8rHHzku28prFL5IC96CS1ySSEziRkf1idvTwVqWU=";

  mypy-boto3-iotevents =
    buildMypyBoto3Package "iotevents" "1.42.3"
      "sha256-uYkkQGEGNQnf/uY1sVR2dkt7TrBTOgG/2YLCdNmp1E8=";

  mypy-boto3-iotevents-data =
    buildMypyBoto3Package "iotevents-data" "1.42.3"
      "sha256-UngbBKgLaBTORn0pbbRTIOc4iqGekayb0IjuU5QrgEo=";

  mypy-boto3-iotfleethub =
    buildMypyBoto3Package "iotfleethub" "1.40.17"
      "sha256-SeJi6Z/TJAiqL6+21CMP6iZF/Skv1hnmldPrJpOHUfo=";

  mypy-boto3-iotfleetwise =
    buildMypyBoto3Package "iotfleetwise" "1.42.3"
      "sha256-BYUvPWrFNSZhMKDlQm0jgcU3utv2cLGKq9POWLLLmXM=";

  mypy-boto3-iotsecuretunneling =
    buildMypyBoto3Package "iotsecuretunneling" "1.42.3"
      "sha256-fFaYE0C7np/DqrRPbqGYNw/dYNkyPot/iF+OufT49Q0=";

  mypy-boto3-iotsitewise =
    buildMypyBoto3Package "iotsitewise" "1.42.3"
      "sha256-U94/P/4BgTFj7J3AYOLiAEGBvXM1keI2c5iAp3x05iM=";

  mypy-boto3-iotthingsgraph =
    buildMypyBoto3Package "iotthingsgraph" "1.42.3"
      "sha256-TxALbXgBraOVwmbJcIiWOx9ZbJA7LkzcswhuFw967/s=";

  mypy-boto3-iottwinmaker =
    buildMypyBoto3Package "iottwinmaker" "1.42.3"
      "sha256-8GAK05LdnC3ve/9Vma/Ej13uCSvTSSC1iYUGr/u3Qgk=";

  mypy-boto3-iotwireless =
    buildMypyBoto3Package "iotwireless" "1.42.3"
      "sha256-tov3sxMjqWU5A7Jr9rQVbi+R/sc9TMeexyjwvgOKuJg=";

  mypy-boto3-ivs =
    buildMypyBoto3Package "ivs" "1.42.3"
      "sha256-TzudGWLWWzTRWZb3585Tkar1iXmt5TtFNox+DJzvhS4=";

  mypy-boto3-ivs-realtime =
    buildMypyBoto3Package "ivs-realtime" "1.42.6"
      "sha256-MjfhT4KcLIDO4iQVo7eyq2K4lqM4anHaDJosPqZdaGw=";

  mypy-boto3-ivschat =
    buildMypyBoto3Package "ivschat" "1.42.3"
      "sha256-eAzIwmz5eZKf2NBGSMw4NopdHqAR5TcF9/0KQqVWr0s=";

  mypy-boto3-kafka =
    buildMypyBoto3Package "kafka" "1.42.50"
      "sha256-gk11rWTYlKHL+PjZvUy+8ZRNHcwC7clIiynVg0EPt8U=";

  mypy-boto3-kafkaconnect =
    buildMypyBoto3Package "kafkaconnect" "1.42.47"
      "sha256-61rA7KEkt8Z/rzOEoArxsuspgfIe+NfjqT4yoCmM/3Q=";

  mypy-boto3-kendra =
    buildMypyBoto3Package "kendra" "1.42.3"
      "sha256-IPlyrXIrWHs9DzrNd4hBqeRNwT5oJ2fQ6zIfSHdGsMc=";

  mypy-boto3-kendra-ranking =
    buildMypyBoto3Package "kendra-ranking" "1.42.3"
      "sha256-rIkIFitznxD9ytbq4cdAbiPTJFZRwZywQ50HVo7D+VU=";

  mypy-boto3-keyspaces =
    buildMypyBoto3Package "keyspaces" "1.42.31"
      "sha256-isLoakoBigys+KBGRoFryEqtKT2g+Wv2D/+ttlxOlfk=";

  mypy-boto3-kinesis =
    buildMypyBoto3Package "kinesis" "1.42.41"
      "sha256-3xWp1Dg6ZC3t0dUNqD+iYJaKAxN5ILv8Sq1QLx7IXvo=";

  mypy-boto3-kinesis-video-archived-media =
    buildMypyBoto3Package "kinesis-video-archived-media" "1.42.3"
      "sha256-XBxm5NK29LZb32jX0RUmmAaYAhvuJYuFenuAmXvcsN0=";

  mypy-boto3-kinesis-video-media =
    buildMypyBoto3Package "kinesis-video-media" "1.42.3"
      "sha256-q7mE4VRVyg912foe+mNVAE2oJezEX+r+ob77kY1RyrI=";

  mypy-boto3-kinesis-video-signaling =
    buildMypyBoto3Package "kinesis-video-signaling" "1.42.3"
      "sha256-WpwJ8fy1YA5ZvVl7JvME6dofkyyJ2qvfP5QRVI5WdAg=";

  mypy-boto3-kinesis-video-webrtc-storage =
    buildMypyBoto3Package "kinesis-video-webrtc-storage" "1.42.3"
      "sha256-5d7z/X+zHGUGYMcs18vXTl2JtiCbq/6ZoW7icoFTv3c=";

  mypy-boto3-kinesisanalytics =
    buildMypyBoto3Package "kinesisanalytics" "1.42.3"
      "sha256-DsxrKv4SwSJc08EAb2kSGFfT+QkU/HQbCiOOirtLpj8=";

  mypy-boto3-kinesisanalyticsv2 =
    buildMypyBoto3Package "kinesisanalyticsv2" "1.42.3"
      "sha256-EgqYSa3GqFX/JE0PJnY3jkG1LTI6VEaREPe2KHuxBf8=";

  mypy-boto3-kinesisvideo =
    buildMypyBoto3Package "kinesisvideo" "1.42.3"
      "sha256-x9ntwcOhUm5Hsd/L+O5N77xJ/NWxgQhNVdtaaShM7p8=";

  mypy-boto3-kms =
    buildMypyBoto3Package "kms" "1.42.50"
      "sha256-bCVvuhK3mpTeNDYDYaACVWgQMhKR9mIi9BbbCI0ynCA=";

  mypy-boto3-lakeformation =
    buildMypyBoto3Package "lakeformation" "1.42.45"
      "sha256-CG1b4lkqvsQLguhkYuJ5CH5Gu0IrC1mbsYYQ2Itjys4=";

  mypy-boto3-lambda =
    buildMypyBoto3Package "lambda" "1.42.37"
      "sha256-lPfwcI+bX/pbiz621WS+HvQC67i4zZYEUzK3o7weoOA=";

  mypy-boto3-lex-models =
    buildMypyBoto3Package "lex-models" "1.42.3"
      "sha256-COIQ8BVxOf44lUIOactGZJK/nYovEOIZ2kvuzME8cos=";

  mypy-boto3-lex-runtime =
    buildMypyBoto3Package "lex-runtime" "1.42.3"
      "sha256-tkSUeZeD8Aa1DzQIDBt8rQYBecfllEyl9kATJkM6FYM=";

  mypy-boto3-lexv2-models =
    buildMypyBoto3Package "lexv2-models" "1.42.3"
      "sha256-1OWMzSKmnpZUEm4yAsjB2tZXEp4Kjix1D3pwx2AAHec=";

  mypy-boto3-lexv2-runtime =
    buildMypyBoto3Package "lexv2-runtime" "1.42.3"
      "sha256-KzxXQppuVCTPDd47r981rhMYk830gcbeXFqvIHQHyEk=";

  mypy-boto3-license-manager =
    buildMypyBoto3Package "license-manager" "1.42.3"
      "sha256-8rAVXY9ZgoPCJ4S4bON2SAMI1zEsVLK3B1M2HY0Pb10=";

  mypy-boto3-license-manager-linux-subscriptions =
    buildMypyBoto3Package "license-manager-linux-subscriptions" "1.42.3"
      "sha256-m/5Zdb1oc/veXnkx5j5EchEXdU7vZsLSoQQAexjtFm0=";

  mypy-boto3-license-manager-user-subscriptions =
    buildMypyBoto3Package "license-manager-user-subscriptions" "1.42.3"
      "sha256-Ru2IODClBpjyDb8JNzBJi9LPY12mg46dpSBz182qkuI=";

  mypy-boto3-lightsail =
    buildMypyBoto3Package "lightsail" "1.42.3"
      "sha256-aku0qwarXhKEB3GK/5Qnn07Qn5RMBZo2l2kJzMpXYHI=";

  mypy-boto3-location =
    buildMypyBoto3Package "location" "1.42.3"
      "sha256-VGQzgnrUynTDjfYpEk+FR+PrljbULl0UpbeqbaPKqSc=";

  mypy-boto3-logs =
    buildMypyBoto3Package "logs" "1.42.10"
      "sha256-Or5B12+lM/6CJUtOAIEjcv2PJA3/18Dd1L40UD0feD8=";

  mypy-boto3-lookoutequipment =
    buildMypyBoto3Package "lookoutequipment" "1.42.3"
      "sha256-C1SPukBZ1zmtayQQY9nnrneSFkQGErLBxDzVYvCH3Xc=";

  mypy-boto3-lookoutmetrics =
    buildMypyBoto3Package "lookoutmetrics" "1.40.15"
      "sha256-ZcL1sZGlckqZFhCqTZwMeghP8K9Hee1Zi3N6wZb9hts=";

  mypy-boto3-lookoutvision =
    buildMypyBoto3Package "lookoutvision" "1.40.59"
      "sha256-MlMkIgzc2D3i5xAPdk+th0e9AYrvRxGwzl4zwEwy4xw=";

  mypy-boto3-m2 =
    buildMypyBoto3Package "m2" "1.42.3"
      "sha256-Uouysx/L59B/V4dG9GWlGulqCwXTQYTTsdyXzrxFSXE=";

  mypy-boto3-machinelearning =
    buildMypyBoto3Package "machinelearning" "1.42.3"
      "sha256-mERVlNSjfxNqfyGRlNgfP1MrzhGrMYgIuZ0pZLPrfBQ=";

  mypy-boto3-macie2 =
    buildMypyBoto3Package "macie2" "1.42.3"
      "sha256-fzZHKPUXOh/tLGCx6xAHJd4jefApYtEwbt6BSakOLXA=";

  mypy-boto3-managedblockchain =
    buildMypyBoto3Package "managedblockchain" "1.42.3"
      "sha256-VHzWqMSf/pfC8NLN7vJftpIVO9u3z/0YhxPezDBxJvg=";

  mypy-boto3-managedblockchain-query =
    buildMypyBoto3Package "managedblockchain-query" "1.42.3"
      "sha256-kiKP12WkHvskEVNPRAUTRJqksrz6I5y31snfFpcz8HQ=";

  mypy-boto3-marketplace-catalog =
    buildMypyBoto3Package "marketplace-catalog" "1.42.41"
      "sha256-lyq6RaR12pc3LKJokhd+S5wSppt4hWdsHoVsQe34GMY=";

  mypy-boto3-marketplace-entitlement =
    buildMypyBoto3Package "marketplace-entitlement" "1.42.58"
      "sha256-vD0N5KMd6GE/UyMuhaULwwKNDy8ndKPSbW0bLo3eW5g=";

  mypy-boto3-marketplacecommerceanalytics =
    buildMypyBoto3Package "marketplacecommerceanalytics" "1.42.3"
      "sha256-1cIpxNx/Q1C89D27DO0PTsFRhZvSok7L1e+B6WjPXvs=";

  mypy-boto3-mediaconnect =
    buildMypyBoto3Package "mediaconnect" "1.42.37"
      "sha256-NYn/N65sVAUxA4kTCi/IJNP/QQeutFjH8S7N2AeK3g8=";

  mypy-boto3-mediaconvert =
    buildMypyBoto3Package "mediaconvert" "1.42.37"
      "sha256-Z+TiVg/mjr0vTU+awHlS7GCynOeSl+IPl0n9GaLTsYE=";

  mypy-boto3-medialive =
    buildMypyBoto3Package "medialive" "1.42.56"
      "sha256-MshslPZEBNOuIPrs0w2No6g8UzXNouSdRgM7WAkXlbc=";

  mypy-boto3-mediapackage =
    buildMypyBoto3Package "mediapackage" "1.42.3"
      "sha256-AfhNnU0FEAARqIOysN3XEsNXQN9hhoXNTkRT4oiP56Q=";

  mypy-boto3-mediapackage-vod =
    buildMypyBoto3Package "mediapackage-vod" "1.42.3"
      "sha256-ZbxRVZaTcS4k2d0+qAT8GOK5tieYduZ4FqXd/k+CElk=";

  mypy-boto3-mediapackagev2 =
    buildMypyBoto3Package "mediapackagev2" "1.42.12"
      "sha256-29Et9fpHzmYz9kL9us/x9Tt8Nq7WQC3UWb5jBmPUOUI=";

  mypy-boto3-mediastore =
    buildMypyBoto3Package "mediastore" "1.42.3"
      "sha256-BieG4cimqiiVqdP7/J1tsCc5YQlVEbiA5bOYCvUBspY=";

  mypy-boto3-mediastore-data =
    buildMypyBoto3Package "mediastore-data" "1.42.3"
      "sha256-VBsw9c9B6r3G5vJ0iVUCi4wVoFprYseRLeMWs69KpTQ=";

  mypy-boto3-mediatailor =
    buildMypyBoto3Package "mediatailor" "1.42.55"
      "sha256-j3ZEfGrynOyodn/Dl8D986+C/+GNkNgSNoAoXMyPhdQ=";

  mypy-boto3-medical-imaging =
    buildMypyBoto3Package "medical-imaging" "1.42.3"
      "sha256-y8iE6GChPXn+MfCa/k8syDRZmhQ8Aaz2uMNdkxMYq1A=";

  mypy-boto3-memorydb =
    buildMypyBoto3Package "memorydb" "1.42.3"
      "sha256-7e9/QHJJbdGyNnpxVZZCdbxdc0ncJ7a2UsBiVF629VA=";

  mypy-boto3-meteringmarketplace =
    buildMypyBoto3Package "meteringmarketplace" "1.42.58"
      "sha256-2mZV1S76X3SaxuZ8OdSpUD3wjGjY+wv0mSJgGBG/d4Q=";

  mypy-boto3-mgh =
    buildMypyBoto3Package "mgh" "1.42.3"
      "sha256-kFHGogiCfbftZr67o8zT7eb8na74J4AGneac03q+Pvc=";

  mypy-boto3-mgn =
    buildMypyBoto3Package "mgn" "1.42.6"
      "sha256-/XANu4whqRXyhbye/Hh3NwJLFpBWWwfBrqdNP4a7Ytg=";

  mypy-boto3-migration-hub-refactor-spaces =
    buildMypyBoto3Package "migration-hub-refactor-spaces" "1.42.3"
      "sha256-22PPd3dk1V3i26ETACZ9nxOjtNNaV/dBT0FxKEBZgkk=";

  mypy-boto3-migrationhub-config =
    buildMypyBoto3Package "migrationhub-config" "1.42.3"
      "sha256-CdCtIzK3FoZsoPIzykK1BE8CXuWNAAG+qhd2HujoS0A=";

  mypy-boto3-migrationhuborchestrator =
    buildMypyBoto3Package "migrationhuborchestrator" "1.42.3"
      "sha256-d42VxAv6JSb35fAax31Sk5qsINDFqMWcvh0KQt1GmZQ=";

  mypy-boto3-migrationhubstrategy =
    buildMypyBoto3Package "migrationhubstrategy" "1.42.3"
      "sha256-MmYBlk+qaxdFtmp0XMK30JwBLxxrlh3tIgdB6Bau19o=";

  mypy-boto3-mq =
    buildMypyBoto3Package "mq" "1.42.3"
      "sha256-/twFblngRZJ99dNaMvxw4elY6Ohjx42edAUdZt8CGnM=";

  mypy-boto3-mturk =
    buildMypyBoto3Package "mturk" "1.42.3"
      "sha256-gnoqOotJJC7ASGttRBWNfO6lBG77KdBGJhGNc8PDjP4=";

  mypy-boto3-mwaa =
    buildMypyBoto3Package "mwaa" "1.42.3"
      "sha256-BkxJ1ilQTVsOqdq63kNtKyKqxrKrEXUkg3v6EN73HR8=";

  mypy-boto3-neptune =
    buildMypyBoto3Package "neptune" "1.42.57"
      "sha256-9oNjBSEUUy4OzQqYVCgujl86TOMyXCT2QMLDG3WU1Kc=";

  mypy-boto3-neptunedata =
    buildMypyBoto3Package "neptunedata" "1.42.45"
      "sha256-shRjfC+W/3ooNeJyGK1U7gdMfx7jRBJjDpiCDwmHONU=";

  mypy-boto3-network-firewall =
    buildMypyBoto3Package "network-firewall" "1.42.3"
      "sha256-1y1aQ8A+XkPyNlXNODlau+Lgfdc6wCgmjiugLWY7nIk=";

  mypy-boto3-networkmanager =
    buildMypyBoto3Package "networkmanager" "1.42.3"
      "sha256-pHiapVK4OoRLk0peUfMu3JRtgBd7vytqv8o3o2q5LK0=";

  mypy-boto3-nimble =
    buildMypyBoto3Package "nimble" "1.35.0"
      "sha256-gs9eGyRaZN7Fsl0D5fSqtTiYZ+Exp0s8QW/X8ZR7guA=";

  mypy-boto3-oam =
    buildMypyBoto3Package "oam" "1.42.3"
      "sha256-CGt/WuKol9nVwLHEwNgEsQDzIBhFarJNbq30OpiK0+I=";

  mypy-boto3-omics =
    buildMypyBoto3Package "omics" "1.42.3"
      "sha256-o2X4h4K/Cf/TnZG3P5uDjdVmYJRcwPlv6DnSwdzOgc0=";

  mypy-boto3-opensearch =
    buildMypyBoto3Package "opensearch" "1.42.56"
      "sha256-yGLOtl1C0Y4F/Q1yDUEx0nR5VcqFFpdt80Eix/DZ5ts=";

  mypy-boto3-opensearchserverless =
    buildMypyBoto3Package "opensearchserverless" "1.42.29"
      "sha256-fC4SP/yP31qx5O5a2rStUATsq+Cs5zWpwGf1XsBWFQI=";

  mypy-boto3-opsworks =
    buildMypyBoto3Package "opsworks" "1.40.0"
      "sha256-ZuSVlDalSjVyMGVem02HklbAmDZXJeWnd2GBrMFJKHU=";

  mypy-boto3-opsworkscm =
    buildMypyBoto3Package "opsworkscm" "1.40.0"
      "sha256-JEuEjo0htTuDCZx2nNJK2Zq59oSUqkMf4BrNamerfVk=";

  mypy-boto3-organizations =
    buildMypyBoto3Package "organizations" "1.42.41"
      "sha256-yx4CFlVDJ7LYV7ShLyNZPYLiSUXLMf2xT3FZBFTV7Xo=";

  mypy-boto3-osis =
    buildMypyBoto3Package "osis" "1.42.3"
      "sha256-+t1Mh2gV7wu5YAFzp0jABFUC6/8P/FHMnBCHilIFXac=";

  mypy-boto3-outposts =
    buildMypyBoto3Package "outposts" "1.42.3"
      "sha256-4+T+yIICXzW6IX90M8y5eOL8jT9r0cJhxeI94SxX6vE=";

  mypy-boto3-panorama =
    buildMypyBoto3Package "panorama" "1.42.3"
      "sha256-ynBHsnTvNz9G8sM9d88RI31ZMl0UzBgIz3ONEsJ+aHA=";

  mypy-boto3-payment-cryptography =
    buildMypyBoto3Package "payment-cryptography" "1.42.12"
      "sha256-MpksWgEGbXdbgF2r6CKcEZif7zzFNqmLrsbvETJAAXc=";

  mypy-boto3-payment-cryptography-data =
    buildMypyBoto3Package "payment-cryptography-data" "1.42.12"
      "sha256-6DvE6qkfAHVvo0xDDA+w1bMacVqejk4kN2a0CiTbP3M=";

  mypy-boto3-pca-connector-ad =
    buildMypyBoto3Package "pca-connector-ad" "1.42.3"
      "sha256-xblYVZWgmt894TaYQ5I2LE7D3aQfOV542+N/ccmcl+Y=";

  mypy-boto3-personalize =
    buildMypyBoto3Package "personalize" "1.42.3"
      "sha256-/cKsRTSz7rt/HNhARxw+JT/V0xNUTdjK7hA2G8Bn19U=";

  mypy-boto3-personalize-events =
    buildMypyBoto3Package "personalize-events" "1.42.3"
      "sha256-Q0bgcDmMPc38oK8ht6Riqa0tMQ6QM9YgnEN2ZbhZbuQ=";

  mypy-boto3-personalize-runtime =
    buildMypyBoto3Package "personalize-runtime" "1.42.3"
      "sha256-YyT/dD0x8U/ubEFBpKvBWiSWQj0ImYblJM0kKB/6ih8=";

  mypy-boto3-pi =
    buildMypyBoto3Package "pi" "1.42.3"
      "sha256-tj7qGsD5o0orvoUcbU7pxmfLwVyu2bux/yEQwYHisns=";

  mypy-boto3-pinpoint =
    buildMypyBoto3Package "pinpoint" "1.42.3"
      "sha256-BojorzQHOokGEYaY38eUKmo4lggBGdcplQw9ZO26p9s=";

  mypy-boto3-pinpoint-email =
    buildMypyBoto3Package "pinpoint-email" "1.42.3"
      "sha256-AcDdmMa0wduyJgWbOjfLcyq5v44Oj8WktWB7PL4Pjso=";

  mypy-boto3-pinpoint-sms-voice =
    buildMypyBoto3Package "pinpoint-sms-voice" "1.42.3"
      "sha256-lDlP16Hoz5J6A/fhL79EgR1livk+WztLLTvy+nLrwhg=";

  mypy-boto3-pinpoint-sms-voice-v2 =
    buildMypyBoto3Package "pinpoint-sms-voice-v2" "1.42.16"
      "sha256-puWanCz8TcXxZSfa9utcHQmu9ETMHpkmLSOMwRdEkhI=";

  mypy-boto3-pipes =
    buildMypyBoto3Package "pipes" "1.42.3"
      "sha256-315QgDF/CNolDYIYUcEGqdc5rQotI1uw0q8aQN9sW08=";

  mypy-boto3-polly =
    buildMypyBoto3Package "polly" "1.42.3"
      "sha256-cPeqJusVAoknOqIsQbtnq5ByHUx8lES4Vnln76wdyF0=";

  mypy-boto3-pricing =
    buildMypyBoto3Package "pricing" "1.42.3"
      "sha256-EY1rb0i7iYzr+JmXvDVfPcxCyNWs0DW0YQdlDsVcb04=";

  mypy-boto3-privatenetworks =
    buildMypyBoto3Package "privatenetworks" "1.38.0"
      "sha256-T04icQC+XwQZhaAEBWRiqfCUaayXP1szpbLdAG/7t3k=";

  mypy-boto3-proton =
    buildMypyBoto3Package "proton" "1.42.3"
      "sha256-YLKdwGViP2a82dXdgk+GW1Xhg3RLhs77g6sB++ACVEQ=";

  mypy-boto3-qldb =
    buildMypyBoto3Package "qldb" "1.40.54"
      "sha256-7h7WswVMGPBf6WsX04+TXA3o8scarCUqnSW3dgUyadw=";

  mypy-boto3-qldb-session =
    buildMypyBoto3Package "qldb-session" "1.40.54"
      "sha256-YrrEKl3aGz//5Z5JGapHhWtk6hBXQ4cuRQmLqGYztzg=";

  mypy-boto3-quicksight =
    buildMypyBoto3Package "quicksight" "1.42.55"
      "sha256-N+w9coq6u6F/B69obbL/N/xL/qsEuSJJVd5WYrnD48Q=";

  mypy-boto3-ram =
    buildMypyBoto3Package "ram" "1.42.59"
      "sha256-jBfqP9lFktW0qJfalR0wGCuHvZv4u6XMoQR466hXLV0=";

  mypy-boto3-rbin =
    buildMypyBoto3Package "rbin" "1.42.3"
      "sha256-55wnvv8vd/G5KdZoJipaSLzC13wRoop7ZXwTLDU4GtE=";

  mypy-boto3-rds =
    buildMypyBoto3Package "rds" "1.42.51"
      "sha256-0J0M9QcOtRrIrtrLY1lNaJ/ownmhyDbfvQanFMqsi94=";

  mypy-boto3-rds-data =
    buildMypyBoto3Package "rds-data" "1.42.3"
      "sha256-XHcwFnP9i2zw5yPwvhcMMCSTmBpQy7ZdxQ4eMR0ao4M=";

  mypy-boto3-redshift =
    buildMypyBoto3Package "redshift" "1.42.42"
      "sha256-hQyZdqznZ8uJVoiwuiVRQRG8fDVWykuyWGJ6BOEc0bE=";

  mypy-boto3-redshift-data =
    buildMypyBoto3Package "redshift-data" "1.42.3"
      "sha256-Mby+hQJcBXqmDY5wC1Uut4EQex1PmjT8bgB81rT5NKU=";

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
    buildMypyBoto3Package "s3" "1.42.37"
      "sha256-YopGUvcnhwoH4cOFTW8w3FRafdWktxmixZwyqV2S5ME=";

  mypy-boto3-s3control =
    buildMypyBoto3Package "s3control" "1.42.37"
      "sha256-t4obevidkovfitA/wQXCMJGcvBTKPDOxWqsHUbK0cHk=";

  mypy-boto3-s3outposts =
    buildMypyBoto3Package "s3outposts" "1.42.3"
      "sha256-juVfwdjPDNPaT5tvyXpzDtomugqxeu++AERLkVtFIxw=";

  mypy-boto3-sagemaker =
    buildMypyBoto3Package "sagemaker" "1.42.49"
      "sha256-mRYxS3oZYjViDoCQEcdBiujOXEMUw/GaeXpO/sAO4EI=";

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
    buildMypyBoto3Package "savingsplans" "1.42.3"
      "sha256-91gIxXdxKevS9es3dQamxTCBjI3B3lJMHQUZrkrfXxQ=";

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
    buildMypyBoto3Package "securityhub" "1.42.58"
      "sha256-svAuxOrTZz/fludiFZFolRVMQmS2qdaJBrfTlynb8oA=";

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
    buildMypyBoto3Package "sesv2" "1.42.13"
      "sha256-NYkCDx1U7URYhRws0bM5/E8eSdWpBKZgydeLEKlBaqI=";

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
    buildMypyBoto3Package "snowball" "1.42.3"
      "sha256-hRI6ESK7/wbcKYo5aB2W5QXQ0hDrfKIHTTyN/RpEYrA=";

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
    buildMypyBoto3Package "sso-oidc" "1.42.3"
      "sha256-ha0ieZCLsp4m+JOpa1DaovuteMQXFvFDLNhMULVeh2I=";

  mypy-boto3-stepfunctions =
    buildMypyBoto3Package "stepfunctions" "1.42.3"
      "sha256-vzj520LhROhseAff8SdVTe/hVIoQuiWCT2nMdFVPpbU=";

  mypy-boto3-storagegateway =
    buildMypyBoto3Package "storagegateway" "1.42.3"
      "sha256-92jALXRmjt/8Ji99jF3304T/xKW+gV1Ix3/N+fmodJc=";

  mypy-boto3-sts =
    buildMypyBoto3Package "sts" "1.42.3"
      "sha256-OFfFuj86XAQX7cR/WtTkWJHjurwy1WxrJ8XUFn+fW6c=";

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
    buildMypyBoto3Package "transfer" "1.42.45"
      "sha256-Aimr6OVNbdCszU1sytZtRtyNn+J4gycTc3q8/9TKgs0=";

  mypy-boto3-translate =
    buildMypyBoto3Package "translate" "1.42.3"
      "sha256-olIHhtYBAz8+avIUNnLoD2pdMq+TLrB8Mn+haKeUl/0=";

  mypy-boto3-verifiedpermissions =
    buildMypyBoto3Package "verifiedpermissions" "1.42.33"
      "sha256-Hu79PPqjMZIddiH3DQyY0XqhbPsXM61BhR6iWKsMcRk=";

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
    buildMypyBoto3Package "workspaces" "1.42.43"
      "sha256-uZ/xdc5xCp0Kb+5LlHGEyo+iBB1iWB7Jo9szx+aY4SQ=";

  mypy-boto3-workspaces-web =
    buildMypyBoto3Package "workspaces-web" "1.42.51"
      "sha256-1LoVLQsBJnWfTwVi9F4kJjZhFWq71/uZPDDV7az9xGI=";

  mypy-boto3-xray =
    buildMypyBoto3Package "xray" "1.42.3"
      "sha256-gJLEGWfu0tD+4JaiKwgrsQfP4rtGeo3X+9w5JZPxlpw=";
}
