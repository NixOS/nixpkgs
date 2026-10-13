#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nixfmt-tree nix-update xmlstarlet

set -eu -o pipefail

nix-update python3Packages.aliyun-python-sdk-core --commit --build

source_file=pkgs/development/python-modules/aliyun-python-sdk/default.nix

packages=(
  aliyun-python-sdk-actiontrail
  aliyun-python-sdk-adb
  aliyun-python-sdk-adcp
  aliyun-python-sdk-address-purification
  aliyun-python-sdk-aicontent
  aliyun-python-sdk-aigen
  aliyun-python-sdk-aimath
  aliyun-python-sdk-aimiaobi
  aliyun-python-sdk-aipodcast
  aliyun-python-sdk-airec
  aliyun-python-sdk-airticketopen
  aliyun-python-sdk-alb
  aliyun-python-sdk-alidns
  aliyun-python-sdk-alikafka
  aliyun-python-sdk-alimt
  aliyun-python-sdk-alinlp
  aliyun-python-sdk-amqp-open
  aliyun-python-sdk-antiddos-public
  aliyun-python-sdk-anytrans
  aliyun-python-sdk-apds
  aliyun-python-sdk-appstream-center
  aliyun-python-sdk-aps
  aliyun-python-sdk-arms
  aliyun-python-sdk-avatar
  aliyun-python-sdk-bailianchatbot
  aliyun-python-sdk-beian
  aliyun-python-sdk-bpstudio
  aliyun-python-sdk-brain-industrial
  aliyun-python-sdk-brinekingdom
  aliyun-python-sdk-bssopenapi
  aliyun-python-sdk-btripopen
  aliyun-python-sdk-buss
  aliyun-python-sdk-cams
  aliyun-python-sdk-captcha
  # aliyun-python-sdk-cas, not maintained anymore
  aliyun-python-sdk-cassandra
  aliyun-python-sdk-cbn
  aliyun-python-sdk-cc5g
  aliyun-python-sdk-ccc
  aliyun-python-sdk-cciotgw
  aliyun-python-sdk-cdn
  aliyun-python-sdk-cdrs
  aliyun-python-sdk-ciomarketpop
  aliyun-python-sdk-clickhouse
  aliyun-python-sdk-cloudapi
  aliyun-python-sdk-cloudauth
  aliyun-python-sdk-cloudauth-console
  aliyun-python-sdk-cloudesl
  aliyun-python-sdk-cloudphone
  aliyun-python-sdk-cloud-siem
  aliyun-python-sdk-cms
  aliyun-python-sdk-codeup
  aliyun-python-sdk-companyreg
  aliyun-python-sdk-computenest
  aliyun-python-sdk-computenestsupplier
  aliyun-python-sdk-config
  aliyun-python-sdk-csas
  aliyun-python-sdk-das
  aliyun-python-sdk-dashdeviceconsole
  aliyun-python-sdk-dataphin-public
  aliyun-python-sdk-dataworks-public
  aliyun-python-sdk-dbfs
  aliyun-python-sdk-dbs
  aliyun-python-sdk-dcdn
  aliyun-python-sdk-ddosbgp
  aliyun-python-sdk-ddoscoo
  aliyun-python-sdk-ddosdiversion
  aliyun-python-sdk-dds
  aliyun-python-sdk-devops-rdc
  aliyun-python-sdk-dfs
  aliyun-python-sdk-dg
  aliyun-python-sdk-dms
  aliyun-python-sdk-dms-dg
  aliyun-python-sdk-dms-enterprise
  aliyun-python-sdk-documentautoml
  aliyun-python-sdk-domain
  aliyun-python-sdk-drds
  aliyun-python-sdk-dt-oc-info
  aliyun-python-sdk-dts
  aliyun-python-sdk-dybaseapi
  aliyun-python-sdk-dyplsapi
  aliyun-python-sdk-dypnsapi
  aliyun-python-sdk-dypnsapi-intl
  aliyun-python-sdk-dysmsapi
  aliyun-python-sdk-dytnsapi
  aliyun-python-sdk-dyvmsapi
  aliyun-python-sdk-eais
  aliyun-python-sdk-eas
  aliyun-python-sdk-ebs
  aliyun-python-sdk-ecd
  aliyun-python-sdk-eci
  aliyun-python-sdk-ecs
  aliyun-python-sdk-ecs-workbench
  aliyun-python-sdk-edas
  aliyun-python-sdk-eds-user
  aliyun-python-sdk-eduinterpreting
  aliyun-python-sdk-eflo
  aliyun-python-sdk-eflo-controller
  aliyun-python-sdk-ehpc
  aliyun-python-sdk-ehpcinstant
  aliyun-python-sdk-eiam
  aliyun-python-sdk-eipanycast
  aliyun-python-sdk-elasticsearch
  aliyun-python-sdk-emas-appmonitor
  aliyun-python-sdk-emr
  aliyun-python-sdk-emrstudio
  aliyun-python-sdk-ens
  aliyun-python-sdk-esa
  aliyun-python-sdk-ess
  aliyun-python-sdk-es-serverless
  aliyun-python-sdk-et-industry-openapi
  aliyun-python-sdk-eventbridge
  aliyun-python-sdk-facebody
  aliyun-python-sdk-fnf
  aliyun-python-sdk-foas
  aliyun-python-sdk-ft
  aliyun-python-sdk-ga
  aliyun-python-sdk-gdb
  aliyun-python-sdk-geoip
  aliyun-python-sdk-governance
  aliyun-python-sdk-gpdb
  aliyun-python-sdk-grace
  aliyun-python-sdk-green
  aliyun-python-sdk-gwlb
  aliyun-python-sdk-hbase
  aliyun-python-sdk-hbr
  aliyun-python-sdk-hcs-mgw
  aliyun-python-sdk-hitsdb
  aliyun-python-sdk-ice
  aliyun-python-sdk-idaas-doraemon
  aliyun-python-sdk-imageaudit
  aliyun-python-sdk-imageenhan
  aliyun-python-sdk-imageprocess
  aliyun-python-sdk-imagerecog
  aliyun-python-sdk-imageseg
  aliyun-python-sdk-imarketing
  aliyun-python-sdk-imgsearch
  aliyun-python-sdk-imm
  aliyun-python-sdk-intlmarket
  aliyun-python-sdk-iot
  aliyun-python-sdk-iotcc
  aliyun-python-sdk-iqs
  aliyun-python-sdk-itag
  aliyun-python-sdk-ivision
  aliyun-python-sdk-kms
  aliyun-python-sdk-lingmou
  aliyun-python-sdk-linkvisual
  aliyun-python-sdk-linkwan
  aliyun-python-sdk-live
  aliyun-python-sdk-ltl
  aliyun-python-sdk-lto
  aliyun-python-sdk-market
  aliyun-python-sdk-marketplaceintl
  aliyun-python-sdk-maxcompute
  aliyun-python-sdk-mns-open
  aliyun-python-sdk-moguan-sdk
  aliyun-python-sdk-msccommonquery
  aliyun-python-sdk-mse
  aliyun-python-sdk-mseap
  aliyun-python-sdk-mts
  aliyun-python-sdk-nas
  aliyun-python-sdk-nis
  aliyun-python-sdk-nlb
  aliyun-python-sdk-nlp-automl
  aliyun-python-sdk-objectdet
  aliyun-python-sdk-oceanbasepro
  aliyun-python-sdk-ocr
  aliyun-python-sdk-oms
  aliyun-python-sdk-ons
  aliyun-python-sdk-onsmqtt
  aliyun-python-sdk-oos
  aliyun-python-sdk-openanalytics-open
  aliyun-python-sdk-openitag
  aliyun-python-sdk-opensearch
  aliyun-python-sdk-osssddp
  aliyun-python-sdk-outboundbot
  aliyun-python-sdk-pai-dsw
  aliyun-python-sdk-paielasticdatasetaccelerator
  aliyun-python-sdk-paifeaturestore
  aliyun-python-sdk-pairecservice
  aliyun-python-sdk-polardb
  aliyun-python-sdk-polardbx
  aliyun-python-sdk-privatelink
  aliyun-python-sdk-push
  aliyun-python-sdk-pvtz
  aliyun-python-sdk-qianzhou
  aliyun-python-sdk-qualitycheck
  aliyun-python-sdk-quickbi-public
  aliyun-python-sdk-quotas
  aliyun-python-sdk-ram
  aliyun-python-sdk-rds
  aliyun-python-sdk-rds-data
  aliyun-python-sdk-reid-cloud
  aliyun-python-sdk-resourcecenter
  aliyun-python-sdk-resourcemanager
  aliyun-python-sdk-resourcesharing
  aliyun-python-sdk-retailcloud
  aliyun-python-sdk-r-kvstore
  aliyun-python-sdk-ros
  aliyun-python-sdk-rsimganalys
  aliyun-python-sdk-rtc
  aliyun-python-sdk-sae
  aliyun-python-sdk-safconsole
  aliyun-python-sdk-sas
  aliyun-python-sdk-sasti
  aliyun-python-sdk-scdn
  aliyun-python-sdk-schedulerx2
  aliyun-python-sdk-schedulerx3
  aliyun-python-sdk-scsp
  aliyun-python-sdk-sddp
  aliyun-python-sdk-selectdb
  aliyun-python-sdk-sgw
  aliyun-python-sdk-slb
  aliyun-python-sdk-sls
  aliyun-python-sdk-smartag
  aliyun-python-sdk-smartsales
  aliyun-python-sdk-smc
  aliyun-python-sdk-snsuapi
  aliyun-python-sdk-sophonsoar
  aliyun-python-sdk-sts
  aliyun-python-sdk-swas-open
  aliyun-python-sdk-tag
  aliyun-python-sdk-threedvision
  aliyun-python-sdk-tingwu
  aliyun-python-sdk-unimkt
  aliyun-python-sdk-ververica
  aliyun-python-sdk-viapi
  aliyun-python-sdk-viapi-oxs-cross
  aliyun-python-sdk-viapi-regen
  aliyun-python-sdk-videoenhan
  aliyun-python-sdk-videorecog
  aliyun-python-sdk-videoseg
  aliyun-python-sdk-vod
  aliyun-python-sdk-voicenavigator
  aliyun-python-sdk-vpc
  aliyun-python-sdk-vpcpeer
  aliyun-python-sdk-vs
  aliyun-python-sdk-waf-openapi
  aliyun-python-sdk-websitebuild
  aliyun-python-sdk-wfts
  aliyun-python-sdk-workbench-ide
  aliyun-python-sdk-workorder
  aliyun-python-sdk-wss
  aliyun-python-sdk-xtrace
)

for package in "${packages[@]}"; do
  package_short_name="${package#aliyun-python-sdk-}"
  old_version=$(awk -v pkg="\"$package_short_name\"" -F'"' '$0 ~ pkg {printf $4}' ${source_file})
  version=$(curl -s https://pypi.org/pypi/${package}/json | jq -r '.info.version')

  echo "Updating ${package} from ${old_version} to ${version}"

  if [ "${version}" != "${old_version}" ]; then
    url=$(curl -s "https://pypi.org/pypi/${package}/${version}/json" | jq -r '.urls[] | select(.packagetype == "sdist") | .url' | head -1)
    if [ -z "$url" ]; then
      url=$(curl -s "https://pypi.org/pypi/${package}/${version}/json" | jq -r '.urls[0].url')
    fi
    hash=$(nix-prefetch-url --type sha256 $url)
    sri_hash="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 $hash)"

    awk -i inplace -v pkg="\"$package_short_name\"" -v new_version="$version" -v new_sha256="$sri_hash" '
      # Match the line containing the package name
      $0 ~ pkg && $0 ~ /buildAliyunSdkPackage/ {
        # Update the version
        sub(/"[^"]+"/, "\"" new_version "\"", $3);
        print;
        # Update the next line with the new sha256
        getline;
        sub(/"[^"]+"/, "\"" new_sha256 "\"");
      }
      { print }
    ' ${source_file}

    treefmt ${source_file}

    git commit ${source_file} -m "python3Packages.${package}: ${old_version} -> ${version}"
  fi

done
