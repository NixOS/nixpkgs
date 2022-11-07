{ fetchzip
, mirror1
, mirror2
}:

{
  matrix-01 = fetchzip {
    sha256 = "sha256-AHur5ZIDZTFRrO2GV0ieXrffq4KUiGWiZ59pv0fUtEQ=";

    urls = [
      "${mirror1}/SNAP/amazon0312.tar.gz"
      "${mirror2}/SNAP/amazon0312.tar.gz"
    ];
  };

  matrix-02 = fetchzip {
    sha256 = "sha256-0rSxaN4lQcdaCLsvlgicG70FXUxXeERPiEmQ4MzbRdE=";

    urls = [
      "${mirror1}/Muite/Chebyshev4.tar.gz"
      "${mirror2}/Muite/Chebyshev4.tar.gz"
    ];
  };

  matrix-03 = fetchzip {
    sha256 = "sha256-hDzDWDUnHEyFedX/tMNq83ZH8uWyM4xtZYUUAD3rizo=";

    urls = [
      "${mirror1}/FEMLAB/sme3Dc.tar.gz"
      "${mirror2}/FEMLAB/sme3Dc.tar.gz"
    ];
  };

  matrix-04 = fetchzip {
    sha256 = "sha256-GmN2yOt/MoX01rKe05aTyB3ypUP4YbQGOITZ0BqPmC0=";

    urls = [
      "${mirror1}/Williams/webbase-1M.tar.gz"
      "${mirror2}/Williams/webbase-1M.tar.gz"
    ];
  };

  matrix-05 = fetchzip {
    sha256 = "sha256-gQNjfVyWzNM9RwImJGhkhahRmZz74LzDs1oijL7mI7k=";

    urls = [
      "${mirror1}/Williams/mac_econ_fwd500.tar.gz"
      "${mirror2}/Williams/mac_econ_fwd500.tar.gz"
    ];
  };

  matrix-06 = fetchzip {
    sha256 = "sha256-87cdZjntNcTuz5BtO59irhcuRbPllWSbhCEX3Td02qc=";

    urls = [
      "${mirror1}/Williams/mc2depi.tar.gz"
      "${mirror2}/Williams/mc2depi.tar.gz"
    ];
  };

  matrix-07 = fetchzip {
    sha256 = "sha256-WRamuJX3D8Tm+k0q67RjUDG3DeNAxhKiaPkk5afY5eU=";

    urls = [
      "${mirror1}/Bova/rma10.tar.gz"
      "${mirror2}/Bova/rma10.tar.gz"
    ];
  };

  matrix-08 = fetchzip {
    sha256 = "sha256-5dhkm293Mc3lzakKxHy5W5XIn4Rw+gihVh7gyrjEHXo=";

    urls = [
      "${mirror1}/JGD_BIBD/bibd_22_8.tar.gz"
      "${mirror2}/JGD_BIBD/bibd_22_8.tar.gz"
    ];
  };

  matrix-09 = fetchzip {
    sha256 = "sha256-czjLWCjXAjZCk5TGYHaEkwSAzQu3TQ3QyB6eNKR4G88=";

    urls = [
      "${mirror1}/Hamm/scircuit.tar.gz"
      "${mirror2}/Hamm/scircuit.tar.gz"
    ];
  };

  matrix-10 = fetchzip {
    sha256 = "sha256-bYuLnJViAIcIejAkh69/bsNAVIDU4wfTLtD+nmHd6FM=";

    urls = [
      "${mirror1}/Sandia/ASIC_320k.tar.gz"
      "${mirror2}/Sandia/ASIC_320k.tar.gz"
    ];
  };

  matrix-11 = fetchzip {
    sha256 = "sha256-aDwn8P1khYjo2Agbq5m9ZBInJUxf/knJNvyptt0fak0=";

    urls = [
      "${mirror1}/GHS_psdef/bmwcra_1.tar.gz"
      "${mirror2}/GHS_psdef/bmwcra_1.tar.gz"
    ];
  };

  matrix-12 = fetchzip {
    sha256 = "sha256-8OJqA/byhlAZd869TPUzZFdsOiwOoRGfKyhM+RMjXoY=";

    urls = [
      "${mirror1}/HB/nos1.tar.gz"
      "${mirror2}/HB/nos1.tar.gz"
    ];
  };

  matrix-13 = fetchzip {
    sha256 = "sha256-FS0rKqmg+uHwsM/yGfQLBdd7LH/rUrdutkNGBD/Mh1I=";

    urls = [
      "${mirror1}/HB/nos2.tar.gz"
      "${mirror2}/HB/nos2.tar.gz"
    ];
  };

  matrix-14 = fetchzip {
    sha256 = "sha256-DANnlrNJikrI7Pst9vRedtbuxepyHmCIu2yhltc4Qcs=";

    urls = [
      "${mirror1}/HB/nos3.tar.gz"
      "${mirror2}/HB/nos3.tar.gz"
    ];
  };

  matrix-15 = fetchzip {
    sha256 = "sha256-21mUgqjWGUfYgiWwSrKh9vH8Vdt3xzcefmqYNYRpxiY=";

    urls = [
      "${mirror1}/HB/nos4.tar.gz"
      "${mirror2}/HB/nos4.tar.gz"
    ];
  };

  matrix-16 = fetchzip {
    sha256 = "sha256-FOuXvGqBBFNkVS6cexmkluret54hCfCOdK+DOZllE4c=";

    urls = [
      "${mirror1}/HB/nos5.tar.gz"
      "${mirror2}/HB/nos5.tar.gz"
    ];
  };

  matrix-17 = fetchzip {
    sha256 = "sha256-+7NI1rA/qQxYPpjXKHvAaCZ+LSaAJ4xuJvMRMBEUYxg=";

    urls = [
      "${mirror1}/HB/nos6.tar.gz"
      "${mirror2}/HB/nos6.tar.gz"
    ];
  };

  matrix-18 = fetchzip {
    sha256 = "sha256-q3NxJjbwGGcFiQ9nhWfUKgZmdVwCfPmgQoqy0AqOsNc=";

    urls = [
      "${mirror1}/HB/nos7.tar.gz"
      "${mirror2}/HB/nos7.tar.gz"
    ];
  };

  matrix-19 = fetchzip {
    sha256 = "sha256-0GAN6qmVfD+tprIigzuUUUwm5KVhkN9X65wMEvFltDY=";

    urls = [
      "${mirror1}/DNVS/shipsec1.tar.gz"
      "${mirror2}/DNVS/shipsec1.tar.gz"
    ];
  };
}
