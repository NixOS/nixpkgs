#! @shell@ -e

export STATE_DIR="${STATE_DIR-/var/lib/unittcms}"
export NODE_ENV="${NODE_ENV-@defaultNodeEnv@}"

ln -sf @out@/lib/node_modules/unittcms-backend/{config,migrations,node_modules,models} "$STATE_DIR"

pushd "$STATE_DIR" > /dev/null
@nodejs@/bin/npx sequelize-cli "$@"
popd > /dev/null
