#!/usr/bin/env nix-shell
#!nix-shell -p curl -p jq -p common-updater-scripts -i bash
set -e

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

entryPointURL='https://customerconnect.omnissa.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=desktop_end_user_computing&product=vmware_horizon_clients&version=horizon_8&dlgType=PRODUCT_BINARY'

function getTarballMetaUrl {
    curl "$entryPointURL" | jq -r '
        .dlgEditionsLists | .[] | select(.name | contains("Client for Linux")) |
        .dlgList | .[] | select(.name | contains("tarball version")) |
        @uri "https://customerconnect.omnissa.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=\(.code)&productId=\(.productId)&rPId=\(.releasePackageId)"
    '
}

meta="$( curl "$(getTarballMetaUrl)" | jq ".downloadFiles | .[]" )"

ver="$( echo "$meta" | jq -r .version )"
url="$( echo "$meta" | jq -r .thirdPartyDownloadUrl )"
sum="$( echo "$meta" | jq -r .sha256checksum )"

echo
echo "version: $ver"
echo "tar url: $url"
echo " sha256: $sum"

cd "${SCRIPT_DIRECTORY}/../../../../.."
update-source-version vmware-horizon-client.unwrapped "$ver" "$sum" "$url"
