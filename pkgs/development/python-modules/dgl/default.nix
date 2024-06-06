{
  buildPythonPackage,
  cmake,
  cudaPackages,
  cython,
  fetchFromGitHub,
  gtest,
  keras,
  lib,
  networkx,
  numpy,
  pandas,
  pip,
  psutil,
  pydantic,
  pytest,
  python,
  requests,
  scikit-learn,
  scipy,
  # tensorflow-build and torch use different grpcio, tensorboard and protobuf versions
  # so they can't be used at the same time
  withTorch ? true,
  withTensorflow ? false,
  tensorflow,
  torch,
  tqdm,
}:
let
  pname = "dgl";
  version = "1.1.3";

  # All of these tests fail because they use network.
  pytorchDisabledTests = [
    "test_cluster_gcn[0]"
    "test_cluster_gcn[4]"
    "test_dataloader_worker_init_fn"
    "test_graph_dataloader[16]"
    "test_graph_dataloader[None]"
    "test_saint[edge-0]"
    "test_saint[edge-4]"
    "test_saint[node-0]"
    "test_saint[node-4]"
    "test_saint[walk-0]"
    "test_saint[walk-4]"
    "test_shadow[0]"
    "test_shadow[4]"
    "test_sparse_opt"
  ];

  commonDisabledTests = [
    "test_actor"
    "test_add_node_property_split"
    "test_add_nodepred_split"
    "test_adj[idtype0]"
    "test_adj[idtype1]"
    "test_as_graphpred"
    "test_as_graphpred_ogb"
    "test_as_graphpred_reprocess"
    "test_as_linkpred"
    "test_as_linkpred_ogb"
    "test_as_nodepred1"
    "test_as_nodepred2"
    "test_as_nodepred_ogb"
    "test_chameleon"
    "test_citation_graph"
    "test_cluster"
    "test_cornell"
    "test_explain_syn"
    "test_fakenews"
    "test_flickr"
    "test_fraud"
    "test_gather_mm_idx_b[dtype1-0.02-256]"
    "test_gin"
    "test_global_uniform_negative_sampling[int32]"
    "test_global_uniform_negative_sampling[int64]"
    "test_gnn_benchmark"
    "test_pattern"
    "test_reddit"
    "test_squirrel"
    "test_texas"
    "test_tudataset_regression"
    "test_wiki_cs"
    "test_wisconsin"
    "test_zinc"
  ];

  distributedDisabledTests = [
    "test_dataloader[edge-0-3]"
    "test_dataloader[edge-4-3]"
    "test_dataloader[node-0-3]"
    "test_dataloader[node-4-3]"
    "test_dist_dataloader[1-False-0-3]"
    "test_dist_dataloader[1-False-4-3]"
    "test_dist_dataloader[1-True-0-3]"
    "test_dist_dataloader[1-True-4-3]"
    "test_dist_emb_server_client"
    "test_dist_optim_server_client"
    "test_kv_multi_role"
    "test_kv_store"
    "test_multi_client[socket]"
    "test_multi_client[tensorpipe]"
    "test_multi_client_connect[socket]"
    "test_multi_client_connect[tensorpipe]"
    "test_multi_thread_rpc[socket]"
    "test_multi_thread_rpc[tensorpipe]"
    "test_multiple_dist_dataloaders[edge-0-1]"
    "test_multiple_dist_dataloaders[edge-0-4]"
    "test_multiple_dist_dataloaders[edge-1-1]"
    "test_multiple_dist_dataloaders[edge-1-4]"
    "test_multiple_dist_dataloaders[edge-4-1]"
    "test_multiple_dist_dataloaders[edge-4-4]"
    "test_multiple_dist_dataloaders[node-0-1]"
    "test_multiple_dist_dataloaders[node-0-4]"
    "test_multiple_dist_dataloaders[node-1-1]"
    "test_multiple_dist_dataloaders[node-1-4]"
    "test_multiple_dist_dataloaders[node-4-1]"
    "test_multiple_dist_dataloaders[node-4-4]"
    "test_neg_dataloader[0-3]"
    "test_neg_dataloader[4-3]"
    "test_rpc[tensorpipe]"
    "test_rpc_find_edges_shuffle[1]"
    "test_rpc_find_edges_shuffle[2]"
    "test_rpc_get_degree_shuffle[1]"
    "test_rpc_get_degree_shuffle[2]"
    "test_rpc_in_subgraph"
    "test_rpc_sampling_shuffle[1]"
    "test_rpc_sampling_shuffle[2]"
    "test_rpc_timeout[socket]"
    "test_rpc_timeout[tensorpipe]"
    "test_server_client"
    "test_standalone"
    "test_standalone_etype_sampling"
    "test_standalone_sampling"
  ];

  disabledTestString = testsList: "not (${lib.strings.concatStringsSep " or " testsList})";
in

buildPythonPackage {
  inherit pname version;

  format = "other";

  src = fetchFromGitHub {
    owner = "dmlc";
    repo = "dgl";
    rev = "v${version}";
    hash = "sha256-FQxfyHPvqI1x4b3byCrTAf11El2MNOXtb5/jx66Yve4=";
    fetchSubmodules = true;
  };

  dependencies =
    [
      networkx
      numpy
      pandas
      psutil
      pydantic
      requests
      scikit-learn
      scipy
      tqdm
    ]
    ++ lib.optionals withTorch [ torch ]
    ++ lib.optionals withTensorflow [
      keras
      tensorflow
    ];

  nativeCheckInputs = [ pytest ];

  env = {
    # error: 'uintptr_t' in namespace 'std' does not name a type
    CXXFLAGS = "-include cstdint";

    # error: ‘iadjwgt’ may be used uninitialized
    NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";
  };

  cmakeFlags = [
    "-DBUILD_CPP_TEST=ON"
    "-DBUILD_SPARSE=OFF"
    "-DUSE_LIBXSMM=OFF"
  ];

  nativeBuildInputs = [
    cmake
    cython
    pip
  ];

  buildInputs = [
    cudaPackages.cudatoolkit
    gtest
  ];

  buildPhase = ''
    runHook preBuild

    make -j $NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    pushd ../python
    python3 -m pip install . --prefix=$out --no-index
    python3 setup.py build_ext --inplace
    popd

    runHook postInstall
  '';

  doCheck = true;

  checkPhase =
    ''
      runHook preCheck

      export HOME="$(mktemp -d)"

      cd ..

      ./build/runUnitTests

      export PYTHONPATH="$PYTHONPATH:$out/${python.sitePackages}:$src/tests"
      export PATH="$PATH:$out/bin"
    ''
    + lib.optionalString withTorch ''
      export DGLBACKEND=pytorch
      pytest tests/python/pytorch/ -k '${disabledTestString pytorchDisabledTests}' \
       --ignore=tests/python/pytorch/sparse/
      pytest tests/python/common/ -k '${disabledTestString commonDisabledTests}'

      pytest tests/distributed/ -k '${disabledTestString distributedDisabledTests}'
    ''
    +
      lib.optionalString (withTensorflow && withTorch) # should be withTensorflow, but you need 'import torch' to run these
        ''
          export DGLBACKEND=tensorflow
          pytest tests/python/tensorflow/
          pytest tests/python/common/ -k '${disabledTestString commonDisabledTests}'
        ''
    + ''
      runHook postCheck
    '';

  meta = with lib; {
    description = ''
      Python package built to ease deep learning on graph, on top of existing DL frameworks.
    '';
    homepage = "https://www.dgl.ai/";
    maintainers = [ maintainers.dtsykunov ];
    license = licenses.asl20;
  };
}
